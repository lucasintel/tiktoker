module TikToker
  class Client::PortalClient
    USER_AGENT          = "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
    INITIAL_PROPS_REGEX = /<script id="__NEXT_DATA__".*?>(.*?)<\/script>/
    REGEX_MATCH_POS     = 1

    # Find an user by *username*.
    #
    # ```
    # client = Client::PortalClient.new
    # client.find_user("charlidamelio") # => TikTok::UserProfile
    # ```
    def find_user(username : String) : TikTok::InitialProps
      response = Crest.get(
        Util.build_profile_url(username),
        headers: {
          "User-Agent" => USER_AGENT,
        },
        cookies: {
          "sessionid" => TikToker.config.session_id,
        },
        p_addr: TikToker.config.proxy_host,
        p_port: TikToker.config.proxy_port,
        p_user: TikToker.config.proxy_user,
        p_pass: TikToker.config.proxy_pass,
        connect_timeout: TikToker.config.connect_timeout,
        write_timeout: TikToker.config.write_timeout,
        read_timeout: TikToker.config.read_timeout,
        logging: TikToker.config.verbose,
        handle_errors: false,
      )

      case response.status
      when .success?
        # Pass
      when .not_found?
        raise UserNotFoundError.new("TikTok user #{username} does not exist.")
      else
        raise RequestError.new(response)
      end

      if match = response.body.match(INITIAL_PROPS_REGEX)
        pull = JSON::PullParser.new(match[REGEX_MATCH_POS])

        pull.on_key!("props") do
          pull.on_key!("pageProps") { TikTok::InitialProps.new(pull) }
        end
      else
        raise PortalExtractionError.new("Could not extract data from TikTok.")
      end
    end
  end
end
