module TikToker
  struct TikTok::Video
    struct Challenge
      include JSON::Serializable
      include JSON::Serializable::Unmapped

      getter id : String

      getter title : String?

      getter desc : String?

      @[JSON::Field(key: "profileThumb")]
      getter profile_thumb : String?

      @[JSON::Field(key: "profileMedium")]
      getter profile_medium : String?

      @[JSON::Field(key: "profileLarger")]
      getter profile_large : String?

      @[JSON::Field(key: "coverThumb")]
      getter cover_thumb : String?

      @[JSON::Field(key: "coverMedium")]
      getter cover_medium : String?

      @[JSON::Field(key: "coverLarger")]
      getter cover_larger : String?

      @[JSON::Field(key: "isCommerce")]
      getter is_commerce : Bool?
    end
  end
end
