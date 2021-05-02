require "./request_signer/*"

module TikToker
  # The `RequestSigner` module provides interaction with available TikTok API
  # request signer backends. See `RequestSigner::Backend`.
  #
  # ```
  # signer = TikToker::RequestSigner.sign(request, RequestSigner::External)
  # signer # => TikTok::SignedRequest
  # ```
  module RequestSigner
    # Signs a TikTok API request using the provided backend.
    def self.sign(request : Request, signer = RequestSigner::External)
      signer.new(request).call
    end
  end
end
