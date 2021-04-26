module Tiktoker
  struct Tiktok::Video
    struct Duet
      include JSON::Serializable
      include JSON::Serializable::Unmapped

      @[JSON::Field(key: "duetFromId")]
      getter duet_from_id : String
    end
  end
end
