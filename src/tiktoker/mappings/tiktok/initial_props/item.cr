module Tiktoker
  struct Tiktok::InitialProps
    struct Item
      include JSON::Serializable

      getter video : Video
      getter stats : Video::Stats
    end
  end
end
