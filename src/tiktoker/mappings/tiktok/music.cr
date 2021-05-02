module TikToker
  struct TikTok::Music
    include JSON::Serializable
    include JSON::Serializable::Unmapped

    getter id : String

    getter title : String?

    @[JSON::Field(key: "playUrl")]
    getter play_url : String?

    @[JSON::Field(key: "coverThumb")]
    getter cover_thumb : String?

    @[JSON::Field(key: "coverMedium")]
    getter cover_medium : String?

    @[JSON::Field(key: "coverLarge")]
    getter cover_large : String?

    @[JSON::Field(key: "authorName")]
    getter author_name : String?

    getter original : Bool?

    getter duration : Int32?

    getter album : String?
  end
end
