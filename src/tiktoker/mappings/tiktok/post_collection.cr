module TikToker
  struct TikTok::PostCollection
    include JSON::Serializable
    include JSON::Serializable::Unmapped

    @[JSON::Field(key: "statusCode")]
    getter status_code : Int32

    @[JSON::Field(key: "itemList")]
    getter item_list : Array(TikTok::Post)?

    getter cursor : String

    @[JSON::Field(key: "hasMore")]
    getter has_more : Bool
  end
end
