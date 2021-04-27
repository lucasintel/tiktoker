module TikToker
  class UserNotFoundError < Exception
  end

  class ExtractionError < Exception
  end

  class HTTPError < Exception
    delegate :status, to: :response

    getter response : Crest::Response

    def initialize(@response)
    end

    def message
      "Request failed with status #{status.code}: #{status.description}"
    end
  end
end
