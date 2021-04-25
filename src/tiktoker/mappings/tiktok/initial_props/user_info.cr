module Tiktoker
  struct InitialProps
    struct UserInfo
      include JSON::Serializable

      getter user : Creator
      getter stats : Creator::Stats
    end
  end
end
