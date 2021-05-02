module TikToker
  ##
  # Requests

  class RetriesExaustedError < Exception
  end

  class RequestError < Exception
    delegate :status, to: :response

    getter response : Crest::Response

    def initialize(@response)
    end

    def message
      "Request failed with status #{status.code}: #{status.description}"
    end
  end

  ##
  # User Profile

  class UserNotFoundError < Exception
  end

  class NoPostsError < Exception
  end

  class PortalExtractionError < Exception
  end
end
