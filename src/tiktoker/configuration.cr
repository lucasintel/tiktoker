module Tiktoker
  class Configuration
    TIKTOK_HOST      = "m.tiktok.com"
    TIKTOK_TEST_HOST = "t.tiktok.com"
    TIKTOK_PORTAL    = "https://www.tiktok.com"

    property signature_server_url : String = ENV["SIGNATURE_SERVER_URL"]? || ""

    # Tiktok
    property tiktok_host : String = TIKTOK_HOST
    property tiktok_test_host : String = TIKTOK_TEST_HOST
    property tiktok_portal : String = TIKTOK_PORTAL
    property use_test_endpoints : Bool = false

    # Flags
    property verbose : Bool = false
    property quiet : Bool = false

    # Proxy
    property proxy_host : String?
    property proxy_port : Int32?
    property proxy_user : String?
    property proxy_pass : String?

    # Timeout
    property connect_timeout : Int32 = 5
    property write_timeout : Int32 = 5
    property read_timeout : Int32 = 60
  end
end
