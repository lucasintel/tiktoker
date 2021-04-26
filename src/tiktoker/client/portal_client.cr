module Tiktoker
  class Client::PortalClient
    USER_AGENT          = "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
    INITIAL_PROPS_REGEX = /<script id="__NEXT_DATA__".*?>(.*?)<\/script>/
    REGEX_MATCH_POS     = 1

    def find_user(username : String) : Tiktok::InitialProps
      response = Crest.get(
        Util.build_profile_url(username),
        headers: {
          "User-Agent" => USER_AGENT,
        },
        p_addr: Tiktoker.config.proxy_host,
        p_port: Tiktoker.config.proxy_port,
        p_user: Tiktoker.config.proxy_user,
        p_pass: Tiktoker.config.proxy_pass,
        connect_timeout: Tiktoker.config.connect_timeout,
        write_timeout: Tiktoker.config.write_timeout,
        read_timeout: Tiktoker.config.read_timeout,
        logging: Tiktoker.config.verbose,
        handle_errors: false,
      )

      case response.status
      when .success?
        # Pass
      when .not_found?
        raise UserNotFoundError.new("TikTok user #{username} does not exist.")
      else
        raise HTTPError.new(response)
      end

      match = response.body.match(INITIAL_PROPS_REGEX)
      unless match
        raise ExtractionError.new("Could not extract profile data from TikTok portal.")
      end

      pull = JSON::PullParser.new(match[REGEX_MATCH_POS])

      pull.on_key!("props") do
        pull.on_key!("pageProps") do
          return Tiktok::InitialProps.new(pull)
        end
      end
    end
  end
end
