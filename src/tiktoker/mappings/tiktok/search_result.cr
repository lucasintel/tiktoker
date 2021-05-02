require "./search_result/*"

module TikToker
  struct TikTok::SearchResult
    include JSON::Serializable
    include JSON::Serializable::Unmapped

    module UserInfoConverter
      def self.from_json(value : JSON::PullParser)
        value.on_key!("user_info") { User.new(value) }
      end
    end

    @[JSON::Field(
      converter: JSON::ArrayConverter(TikToker::TikTok::SearchResult::UserInfoConverter)
    )]
    getter user_list : Array(User)

    getter status_code : Int32

    getter cursor : Int32

    getter has_more : UInt8
  end
end
