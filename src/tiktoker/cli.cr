module TikToker
  class CLI < Admiral::Command
    BANNER = <<-TXT
    Usage: tiktoker [command] [args]

    Command line client for TikTok.

    Commands:
      user [--help] [identifier] # @command Find a user by identifier.
        @example tiktoker user charlidamelio
        @example tiktoker user secUid:MS4wLjABAAAA-VASjiXTh7wDDyXvjk10VFhMWUAoxr8bgfO1kAL1-9s
        @example tiktoker user id:5831967

    Flags:
      Proxy:
        --proxy-host [host]
        --proxy-port [port]
        --proxy-pass [pass]
        --proxy-user [user]

      Timeout:
        --connect-timeout [seconds] (default: 5)
        --write-timeout [seconds] (default: 5)
        --read-timeout [seconds] (default: 60)

      Error Handling:
        --retry-attempts [attempts] (default: 10)

      Miscellaneous Options:
        --verbose # @flag Print debug information for each operation or request.
        --quiet   # @flag This makes TikToker suitable as a cron job.
    TXT

    define_version TikToker::VERSION
    define_help custom: BANNER

    register_sub_command user : CLI::User, short: "u"

    # Required.
    define_flag signature_server_url : String

    # Proxy.
    define_flag proxy_host : String
    define_flag proxy_port : Int32
    define_flag proxy_user : String
    define_flag proxy_pass : String

    # Timeout.
    define_flag connect_timeout : Int32, default: 5
    define_flag write_timeout : Int32, default: 5
    define_flag read_timeout : Int32, default: 60

    # Error Handling.
    define_flag retry_attempts : Int32, default: 5

    # Miscellaneous Options.
    define_flag verbose : Bool, default: false
    define_flag quiet : Bool, default: false

    def run
      TikToker.config.with do |config|
        config.proxy_host = flags.proxy_host
        config.proxy_port = flags.proxy_port
        config.proxy_user = flags.proxy_user
        config.proxy_pass = flags.proxy_pass

        config.connect_timeout = flags.connect_timeout
        config.write_timeout = flags.write_timeout
        config.read_timeout = flags.read_timeout

        config.retry_attempts = flags.retry_attempts

        config.verbose = flags.verbose
        config.quiet = flags.quiet

        if signature_server_url = flags.signature_server_url.presence
          config.signature_server_url = signature_server_url
        end
      end
    end
  end
end

require "./cli/*"
