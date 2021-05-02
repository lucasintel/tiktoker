module TikToker
  module RequestSigner
    # Base interface to sign TikTok API requests.
    #
    # To implement a `RequestSigner` you need to define a `#call` method that
    # signs the request and returns a `TikToker::SignedRequest`.
    abstract class Backend
      abstract def initialize(request : TikToker::Request)
      abstract def call : TikToker::SignedRequest
    end
  end
end
