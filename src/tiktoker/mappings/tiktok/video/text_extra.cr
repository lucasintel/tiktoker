module Tiktoker
  struct Tiktok::Video
    struct TextExtra
      include JSON::Serializable
      include JSON::Serializable::Unmapped

      @[JSON::Field(key: "awemeId")]
      getter aweme_id : String?

      getter start : UInt16?

      getter end : UInt16?

      @[JSON::Field(key: "hashtagName")]
      getter hashtag_name : String?

      @[JSON::Field(key: "hashtagId")]
      getter hashtag_id : String?

      @[JSON::Field(key: "type")]
      getter type : UInt16?

      @[JSON::Field(key: "userId")]
      getter user_id : String?

      @[JSON::Field(key: "isCommerce")]
      getter is_commerce : Bool?

      @[JSON::Field(key: "userUniqueId")]
      getter user_unique_id : String?

      @[JSON::Field(key: "secUid")]
      getter sec_uid : String?
    end
  end
end
