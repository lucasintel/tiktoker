module TikToker
  struct TikTok::SearchResult
    struct User
      include JSON::Serializable
      include JSON::Serializable::Unmapped

      # Returns the creator secUid, the user unique identifier.
      getter sec_uid : SecUID

      # Returns the creator username.
      getter unique_id : String

      # Returns the creator id.
      getter uid : String?

      getter nickname : String

      getter signature : String

      getter follower_count : UInt64

      getter custom_verify : String?
    end
  end
end
