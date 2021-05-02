module TikToker
  class Configuration
    TIKTOK_HOST   = "www.tiktok.com"
    TIKTOK_PORTAL = "https://www.tiktok.com"

    # External signature server used to sign TikTok API requests. By default,
    # the signature server is expected to be listening locally port 3000.
    property signature_server_url : String = ENV.fetch("SIGNATURE_SERVER_URL", "http://localhost:3000")

    # Seconds to wait before timing out a connection request with an external
    # signature server.
    property signature_server_timeout : Int32 = 1

    # User agent used by TikToker when there is no need to disguise itself,
    # e.g. in requests with an external signature server.
    property internal_user_agent : String = "TikToker/#{VERSION} (+https://github.com/kandayo/tiktoker)"

    # TikTok API host.
    property tiktok_host : String = TIKTOK_HOST

    # TikTok portal URL.
    property tiktok_portal : String = TIKTOK_PORTAL

    # Stop when encountering the first already-downloaded video. This flag is
    # recommended when you use TikToker to update your personal archive.
    property fast_update : Bool = false

    # Used to authenticate with TikTok API. Useful to browse and download
    # private profiles.
    property session_id : String?

    # Timeout waiting for TikTok server connection to open in seconds.
    property connect_timeout : Int32 = 5

    # Timeout when waiting for TikTok server to receive data.
    property write_timeout : Int32 = 5

    # Timeout when waiting for TikTok server to return data.
    property read_timeout : Int32 = 60

    # Maximum number of retry attempts until a request is aborted. When using
    # TikTok as a library, you might want to set it to zero.
    property retry_attempts : Int32 = 5

    # Print debug information for each operation.
    property verbose : Bool = false

    # Do not produce any output. This makes TikToker suitable as a cron job.
    getter quiet : Bool = false

    # Changes the log severity to `Log::Severity::Error` if set to true.
    #
    # ```
    # config.quiet = true
    # ```
    def quiet=(bool : Bool)
      @quiet = bool
      TikToker.setup_logger
    end

    # TikTok device id. Keep in mind that this token is supposed to be
    # long-lived and consistent between requests.
    #
    # ```
    # TikToker::Util.generate_did # => 3745502480601580487
    # ```
    property did : String = Util.generate_did

    # Proxy host.
    #
    # ```
    # config.proxy_host = "localhost"
    # ```
    property proxy_host : String?

    # Proxy port.
    #
    # ```
    # config.proxy_port = 8080
    # ```
    property proxy_port : Int32?

    # Proxy username.
    #
    # ```
    # config.proxy_user = "username"
    # ```
    property proxy_user : String?

    # Proxy password.
    #
    # ```
    # config.proxy_user = "password"
    # ```
    property proxy_pass : String?

    # Configuration for TikToker.
    #
    # ```
    # config = TikToker::Configuration.new
    # config.with do |config|
    #   config.signature_server_url = "https://signature.server"
    # end
    # ```
    def with : Nil
      yield(self)
    end
  end
end
