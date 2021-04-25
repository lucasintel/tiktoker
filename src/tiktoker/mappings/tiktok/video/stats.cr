module Tiktoker
  struct Video
    struct Stats
      include JSON::Serializable
      include JSON::Serializable::Unmapped

      @[JSON::Field(key: "diggCount")]
      getter digg_count : UInt64

      @[JSON::Field(key: "shareCount")]
      getter share_count : UInt64

      @[JSON::Field(key: "commentCount")]
      getter comment_count : UInt64

      @[JSON::Field(key: "playCount")]
      getter play_count : UInt64
    end
  end
end
