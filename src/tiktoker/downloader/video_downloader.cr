module TikToker
  # A `Downloader::VideoDownloader` downloads a single `TikTok::Post`.
  #
  # The video is initially saved to a temporary destination, then it's moved to
  # its definitive destination.
  class Downloader::VideoDownloader
    private USER_AGENT = "user-agent:okhttp"

    Log = ::Log.for(self)

    def initialize(@post : TikTok::Post)
    end

    def call : Bool
      ensure_destination_directory_exists

      File.write(metadata_destination, @post.to_pretty_json)

      if already_downloaded?
        Log.info { " + #{@post.author.nickname} — #{@post.id}.mp4; exists" }
        return false
      end

      Util.retry_on_connection_error do
        Crest.get(
          @post.video.download_addr,
          cookies: {
            "tt_webid"    => TikToker.config.did,
            "tt_webid_v2" => TikToker.config.did,
            "sessionid"   => TikToker.config.session_id,
          },
          headers: {
            "User-Agent" => USER_AGENT,
            "Referer"    => referer,
          },
          p_addr: TikToker.config.proxy_host,
          p_port: TikToker.config.proxy_port,
          p_user: TikToker.config.proxy_user,
          p_pass: TikToker.config.proxy_pass,
          connect_timeout: TikToker.config.connect_timeout,
          write_timeout: TikToker.config.write_timeout,
          read_timeout: TikToker.config.read_timeout,
          logging: TikToker.config.verbose,
        ) do |response|
          if render_progress?
            file_size = response.http_client_res.headers.fetch("Content-Length", 1).to_u64
            progress = build_progress_bar(file_size)
          end

          File.open(temp_destination, "w") do |file|
            buffer = uninitialized UInt8[4096]

            while (len = response.body_io.read(buffer.to_slice).to_i32) > 0
              file.write(buffer.to_slice[0, len])
              progress.tick(len) if progress
            end
          end
        end
      end

      FileUtils.mv(temp_destination, destination)

      true
    rescue TikToker::RetriesExaustedError
      Log.error { " ! Retries exausted: #{@post.video.download_addr}; skipping" }
      true
    end

    private def already_downloaded?
      File.exists?(destination) || File.exists?(backwards_compatible_destination)
    end

    private def ensure_destination_directory_exists : Nil
      Dir.exists?(directory) || Dir.mkdir(directory)
    end

    private def directory : String
      @post.author.sec_uid
    end

    private def metadata_destination : String
      File.expand_path("#{filename}.json", directory)
    end

    private def destination : String
      File.expand_path("#{filename}.mp4", directory)
    end

    private def backwards_compatible_destination
      File.expand_path("#{@post.id}.mp4", directory)
    end

    private def temp_destination
      "#{destination}.temp"
    end

    private def filename : String
      @filename ||= begin
        formatted_timestamp = @post.create_time.to_utc.to_s("%Y-%m-%d %T")
        "#{formatted_timestamp} - #{@post.id}"
      end
    end

    private def referer : String
      "https://www.tiktok.com/@#{@post.author.unique_id}"
    end

    private def build_progress_bar(total : UInt64) : Progress
      progress = Progress.new(
        template: " + {label} {bar} {step} {percent}",
        label: "#{@post.author.nickname} - #{@post.id}",
        total: total,
        width: 30,
      )

      progress.init
      progress
    end

    private def render_progress?
      TikToker.config.verbose || !TikToker.config.quiet
    end
  end
end
