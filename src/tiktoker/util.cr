module TikToker
  module Util
    def self.build_profile_url(username)
      "#{TikToker.config.tiktok_portal}/@#{username}"
    end
  end
end
