module TikToker
  # The `TikToker::RequestBuilder` module provides a minimal interface for
  # building TikTok API requests.
  #
  # See `TikToker::Request`.
  module RequestBuilder
    MAX_POSTS_PER_PAGE = "30"

    def self.user_profile_feed(sec_uid : SecUID, cursor : String, count = MAX_POSTS_PER_PAGE) : Request
      Request.new(
        path: "/api/post/item_list/",
        query: URI::Params.build do |query|
          query.add("aid", "1988")
          query.add("did", TikToker.config.did)
          query.add("secUid", sec_uid)
          query.add("count", count)
          query.add("cursor", cursor)
        end
      )
    end

    def self.search_user(term : String, cursor : String) : Request
      Request.new(
        path: "/api/search/user/full/",
        query: URI::Params.build do |query|
          query.add("aid", "1988")
          query.add("device_id", TikToker.config.did)
          query.add("keyword", term)
          query.add("cursor", cursor)
        end
      )
    end
  end
end
