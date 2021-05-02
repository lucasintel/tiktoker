module TikToker
  class Client::WebApiClient
    # Returns a collection of posts for *sec_uid*, starting from *cursor*.
    # See `TikToker::ProfileIterator`.
    #
    # ```
    # client.user_profile_feed("0x1111", "0") # => TikTok::PostCollection
    # ```
    def user_profile_feed(sec_uid : SecUID, cursor : String) : TikTok::PostCollection
      request = RequestSigner
        .sign(RequestBuilder.user_profile_feed(sec_uid, cursor))

      response = perform(:get, request)

      if response.success?
        TikTok::PostCollection.from_json(response.body)
      else
        raise TikToker::RequestError.new(response)
      end
    end

    # Returns a collection of users that match the given *criteria*, starting
    # from *cursor*.
    #
    # ```
    # client.search_user("willsmith", "0") # => TikTok::SearchResult
    # ```
    def search_user(criteria : String, cursor : String) : TikTok::SearchResult
      request = RequestSigner
        .sign(RequestBuilder.search_user(criteria, cursor))

      response = perform(:get, request)

      if response.success?
        TikTok::SearchResult.from_json(response.body)
      else
        raise TikToker::RequestError.new(response)
      end
    end

    @[AlwaysInline]
    private def perform(method : Symbol, request : TikToker::SignedRequest)
      Crest::Request.execute(
        method,
        request.signed_url,
        headers: {
          "User-Agent" => request.navigator.user_agent,
          "Referer"    => "http://www.tiktok.com",
        },
        cookies: {
          "tt_webid_v2" => TikToker.config.did,
          "tt_webid"    => TikToker.config.did,
          "sessionid"   => TikToker.config.session_id,
          "s_v_web_id"  => request.verify_fp,
        },
        p_addr: TikToker.config.proxy_host,
        p_port: TikToker.config.proxy_port,
        p_user: TikToker.config.proxy_user,
        p_pass: TikToker.config.proxy_pass,
        connect_timeout: TikToker.config.connect_timeout,
        write_timeout: TikToker.config.write_timeout,
        read_timeout: TikToker.config.read_timeout,
        logging: TikToker.config.verbose,
        handle_errors: false
      )
    end
  end
end
