module Tiktoker
  module Util
    def self.build_profile_url(username)
      "#{Tiktoker.config.tiktok_portal}/@#{username}"
    end
  end
end
