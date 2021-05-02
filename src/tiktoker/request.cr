module TikToker
  # A `TikToker::Request` is a wrapper around an `URI` to represent a TikTok
  # API request.
  #
  # ```
  # request = TikToker::Request.new("/api/post/item_list/")
  # request.add("secUid", "0x1111")
  # request.to_s # => "https://m.tiktok.com/api/post/item_list?secUid=0x1111"
  # ```
  class Request
    getter uri : URI

    delegate :query_params, to: @uri
    delegate :[], :[]?, :has_key?, to: :query_params

    def initialize(path : String, query = URI::Params.new)
      @uri = URI.new(
        scheme: "https",
        host: TikToker.config.tiktok_host,
        path: path,
        query: query
      )
    end

    # Sets (and overrides) the *name* query param to *value*.
    #
    # ```
    # request = TikToker::Request.new("/")
    # request.add("did", "0x1111111")
    # request.has_key?("did") # => true
    # request["did"]          # => "0x1111111"
    # ```
    def add(name : String, value) : Nil
      new_params = @uri.query_params
      new_params.delete_all(name)
      new_params.add(name, value.to_s)

      @uri.query_params = new_params
    end

    # Builds the request URL.
    #
    # ```
    # request = TikToker::Request.new("/")
    # request.add("secUid", "0x1111111")
    # request.to_s # => "https://m.tiktok.com/?secUid=0x1111111"
    # ```
    def build : String
      @uri.to_s
    end

    # :ditto:
    def to_s : String
      build
    end
  end
end
