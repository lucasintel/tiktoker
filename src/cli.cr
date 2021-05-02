require "option_parser"
require "tallboy"

require "./tiktoker"

require "./cli/ext/*"
require "./cli/*"

module TikToker
  class CLI
    BANNER = <<-TXT
    Usage: tiktoker [command] [args]

    Command line client for TikTok.

    Commands:
      user [username]
        Find a user by username. E.g. `tiktoker user charlidamelio`.

      search user [criteria]
        Search user by criteria. E.g. `tiktoker search user charlidamelio`.

      download user [username or SecUID]
        Download videos published by the given user.
        It's strongly recommended to use SecUIDs instead of usernames.

      download batch [file]
        File containing users to download, one identifier per line.
        Empty lines or lines starting with '#' are considered as comments and
        ignored.

    Flags:
      -s, --signature-server-url [url]
        External signature server used to sign TikTok API requests.
        By default, the signature server is expected to be listening locally
        on port 3000.

      --fast-update
        Stop when encountering the first already-downloaded video.
        This flag is recommended when you use TikToker to update your personal
        archive.

      -u, --session-id [id]
        Used to authenticate with TikTok API. Useful to browse and download
        private profiles.

      --retry-attempts [attempts; default: 10]
        Maximum number of retry attempts until a request is aborted.

      --connect-timeout [seconds; default: 5]
        Timeout waiting for TikTok server connection to open in seconds.

      --write-timeout [seconds; default: 5]
        Timeout when waiting for TikTok server to receive data.

      --read-timeout [seconds; default: 60]
        Timeout when waiting for TikTok server to return data.

      --verbose
        Print debug information for each operation. Not compatible with quiet.

      --quiet
        Do not produce any output. This makes TikToker suitable as a cron job.

      --proxy-host [host]
      --proxy-port [port]
      --proxy-user [user]
      --proxy-pass [pass]

    Examples:
      tiktoker user charlidamelio
      tiktoker search user charlie
      tiktoker download user charlidamelio dixiedamelio willsmith
      tiktoker download batch file.txt --fast-update
    \n
    TXT

    BLANK = ""

    @args : Array(String)
    @stream : IO::FileDescriptor
    @command : Symbol = :main
    @argument : String = BLANK

    def initialize(@args, @stream = STDOUT)
      OptionParser.parse do |parser|
        parser.on("-s URL", "--signature-server-url URL", BLANK) do |url|
          TikToker.config.signature_server_url = url
        end

        parser.on("-f", "--fast-update", BLANK) do
          TikToker.config.fast_update = true
        end

        parser.on("-u ID", "--session-id ID", BLANK) do |session_id|
          TikToker.config.session_id = session_id
        end

        parser.on("--retry-attempts ATTEMPTS", BLANK) do |attempts|
          TikToker.config.retry_attempts = attempts.to_i
        end

        parser.on("--connect-timeout SECS", BLANK) do |seconds|
          TikToker.config.connect_timeout = seconds.to_i
        end

        parser.on("--write-timeout SECS", BLANK) do |seconds|
          TikToker.config.write_timeout = seconds.to_i
        end

        parser.on("--read-timeout SECS", BLANK) do |seconds|
          TikToker.config.read_timeout = seconds.to_i
        end

        parser.on("-V", "--verbose", BLANK) { TikToker.config.verbose = true }
        parser.on("-q", "--quiet", BLANK) { TikToker.config.quiet = true }

        parser.on("-v", "--version", BLANK) do
          @stream.puts(VERSION)
          exit(0)
        end

        parser.on("-h", "--help", BLANK) do
          @stream.puts(BANNER)
          exit(0)
        end

        {% for flag, _index in %w[host user pass] %}
          parser.on("--proxy-{{flag.id}} VALUE", BLANK) do |value|
            TikToker.config.proxy_{{flag.id}} = value
          end
        {% end %}

        parser.on("--proxy-port PORT", BLANK) do |port|
          TikToker.config.proxy_port = port.to_i
        end

        parser.on("user=USER", BLANK) do |argument|
          @command = :find_user
          @argument = argument

          if argument.nil? || argument.empty?
            @stream.puts("ERROR: Command expected an USER but got nothing.")
            exit(1)
          end
        end

        parser.on("search", BLANK) do
          parser.on("user=USER", BLANK) do |argument|
            @command = :search_user
            @argument = argument

            if argument.nil? || argument.empty?
              @stream.puts("ERROR: Command expected an USER but got nothing")
              exit(1)
            end
          end
        end

        parser.on("download", BLANK) do
          parser.on("batch=FILE", BLANK) do |argument|
            @command = :download_batch
            @argument = argument

            if argument.nil? || argument.empty?
              @stream.puts("ERROR: Command expected a FILE but got nothing")
              exit(1)
            end
          end

          parser.on("user=USER", BLANK) do |argument|
            @command = :download_user
            @argument = argument

            if argument.nil? || argument.empty?
              @stream.puts("ERROR: Command expected an USER but got nothing")
              exit(1)
            end
          end
        end

        parser.missing_option do |flag|
          @stream.puts("ERROR: #{flag} flag expects a argument\n\n")
          exit(1)
        end

        parser.invalid_option do |flag|
          @stream.puts("ERROR: #{flag} is not a valid option.\n\n")
          exit(1)
        end
      end
    end

    def run
      {% for signal in %w[TERM INT] %}
        Signal::{{signal.id}}.trap do
          @stream.puts "\n"
          @stream.puts "Done! Tiktoker received SIG{{signal.id}}"
          exit
        end
      {% end %}

      case @command
      when :search_user
        Command::SearchUser.new(@argument).call
      when :find_user
        Command::FindUser.new(@argument).call
      when :download_batch
        Command::DownloadBatch.new(@argument).call
      when :download_user
        Command::DownloadUser.new(@argument).call
      else
        @stream.puts(BANNER)
      end
    end
  end
end

TikToker::CLI.new(ARGV).run
