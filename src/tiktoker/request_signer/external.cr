require "./base"

module TikToker
  # Implementation of `RequestSigner::Backend` that uses an external signature
  # server to sign TikTok API requests.
  #
  # Network errors are gracefully retried following a randomized exponential
  # backoff technique.
  #
  # ```
  # signer = RequestSigner::External.new(request)
  # signer.call # => SignedRequest
  # ```
  class RequestSigner::External < RequestSigner::Backend
    def initialize(@request : TikToker::Request)
    end

    def call : TikToker::SignedRequest
      response = Util.retry_on_connection_error do
        Crest.post(
          TikToker.config.signature_server_url,
          form: payload,
          headers: {
            "User-Agent" => TikToker.config.internal_user_agent,
          },
          connect_timeout: TikToker.config.signature_server_timeout,
          write_timeout: TikToker.config.signature_server_timeout,
          read_timeout: TikToker.config.signature_server_timeout,
          logging: TikToker.config.verbose,
        )
      end

      TikToker::SignedRequest.from_json(response.body, root: "data")
    end

    private def payload
      {url: @request.build}.to_json
    end
  end
end
