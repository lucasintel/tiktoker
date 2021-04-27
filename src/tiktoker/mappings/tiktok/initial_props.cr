require "./initial_props/*"

module TikToker
  struct TikTok::InitialProps
    include JSON::Serializable

    @[JSON::Field(key: "userInfo")]
    getter user_info : InitialProps::UserInfo

    getter items : Array(InitialProps::Item)
  end
end
