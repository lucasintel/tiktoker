module TikToker
  class Client
    property portal_client = Client::PortalClient.new
    property api_client = Client::WebApiClient.new

    # Portal interface.
    delegate find_user, to: portal_client

    # Web API interface.
    delegate user_profile_feed, search_user, to: api_client
  end
end

require "./client/*"
