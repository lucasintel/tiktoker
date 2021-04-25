require "./initial_props/*"

module Tiktoker
  struct InitialProps
    include JSON::Serializable

    @[JSON::Field(key: "userInfo")]
    getter user_info : InitialProps::UserInfo

    getter items : Array(InitialProps::Item)
  end
end
