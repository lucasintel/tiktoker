module TikToker
  struct TikTok::Post
    include JSON::Serializable
    include JSON::Serializable::Unmapped

    # Returns the video id.
    getter id : String

    # Returns the video description.
    getter desc : String?

    @[JSON::Field(key: "createTime", converter: Time::EpochConverter)]
    # Returns the video upload time.
    getter create_time : Time

    getter video : TikTok::Video

    getter author : TikTok::Creator

    getter music : TikTok::Music

    getter challenges : Array(TikTok::Video::Challenge)?

    getter stats : TikTok::Video::Stats

    @[JSON::Field(key: "duetInfo")]
    getter duet_info : TikTok::Video::Duet?

    @[JSON::Field(key: "originalItem")]
    getter original_item : Bool?

    @[JSON::Field(key: "officalItem")]
    getter official_item : Bool?

    @[JSON::Field(key: "textExtra")]
    getter text_extra : Array(TikTok::Video::TextExtra)?

    getter secret : Bool?

    @[JSON::Field(key: "forFriend")]
    getter for_friend : Bool?

    getter digged : Bool?

    @[JSON::Field(key: "itemCommentStatus")]
    getter item_comment_status : Int32?

    @[JSON::Field(key: "showNotPass")]
    getter show_not_pass : Bool?

    @[JSON::Field(key: "vl1")]
    getter vl1 : Bool?

    @[JSON::Field(key: "itemMute")]
    getter item_mute : Bool?

    @[JSON::Field(key: "authorStats")]
    getter author_stats : TikTok::Creator::Stats

    @[JSON::Field(key: "privateItem")]
    getter private_item : Bool?

    @[JSON::Field(key: "duetEnabled")]
    getter duet_enabled : Bool?

    @[JSON::Field(key: "stitchEnabled")]
    getter stitch_enabled : Bool?

    @[JSON::Field(key: "shareEnabled")]
    getter share_enabled : Bool?

    @[JSON::Field(key: "isAd")]
    getter is_ad : Bool?
  end
end
