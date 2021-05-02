require "crest"
require "file_utils"
require "json"
require "progress"
require "retriable"

require "./tiktoker/types"
require "./tiktoker/**"

# TikToker is an API wrapper and a command-line client for TikTok. It can be
# used as a library or directly from the terminal.
#
# ## Configuration
#
# ```
# TikToker.config.with do |config|
#   config.signature_server_url = "https://passport.internal.docker"
#   config.retry_attempts = 0
# end
# ```
module TikToker
  class_getter config = Configuration.new
  class_getter client = Client.new

  module Delegate
    delegate :find_user, :user_profile_feed, :search_user, to: :client
  end

  extend Delegate
end
