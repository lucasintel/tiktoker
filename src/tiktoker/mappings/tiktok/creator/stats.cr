module Tiktoker
  struct Tiktok::Creator
    struct Stats
      include JSON::Serializable
      include JSON::Serializable::Unmapped

      @[JSON::Field(key: "followerCount")]
      getter follower_count : UInt64

      @[JSON::Field(key: "followingCount")]
      getter following_count : UInt64

      getter heart : UInt64

      @[JSON::Field(key: "heartCount")]
      getter heart_count : UInt64

      @[JSON::Field(key: "videoCount")]
      getter video_count : UInt64
    end
  end
end
