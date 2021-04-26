require "./video/*"

module Tiktoker
  struct Tiktok::Video
    include JSON::Serializable
    include JSON::Serializable::Unmapped

    getter id : String

    getter height : UInt16?

    getter width : UInt16?

    getter duration : UInt16?

    getter ratio : String?

    getter cover : String?

    @[JSON::Field(key: "originCover")]
    getter origin_cover : String?

    @[JSON::Field(key: "dynamicCover")]
    getter dynamic_cover : String?

    @[JSON::Field(key: "playAddr")]
    getter play_addr : String?

    @[JSON::Field(key: "downloadAddr")]
    getter download_addr : String

    @[JSON::Field(key: "shareCover")]
    getter share_covers : Array(String)?

    @[JSON::Field(key: "reflowCover")]
    getter reflow_cover : String?

    getter bitrate : UInt64?

    @[JSON::Field(key: "encodedType")]
    getter encoded_type : String?

    getter format : String?
  end
end
