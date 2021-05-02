module TikToker
  module Util
    # Builds a `TikTok::UserProfile` URL. Used to extract user info directly
    # from the portal.
    #
    # ```
    # TikTok::Util.build_profile_url("username")
    # # => https://www.tiktok.com/@username?lang=en
    # ```
    def self.build_profile_url(username, language = "en")
      "#{TikToker.config.tiktok_portal}/@#{username}?lang=#{language}"
    end

    # Generates a random TikTok *did* (device ID). Keep in mind that this token
    # is supposed to be long-lived and consistent between requests.
    #
    # ```
    # TikTok::Util.generate_did # => 3745502480601580487
    # ```
    def self.generate_did : String
      StaticArray(Int32, 19).new { Random.rand(10) }.join
    end

    def self.retry_on_connection_error(&block)
      on_retry_callback =
        ->(ex : Exception, attempt : Int32, _elapsed_time : Time::Span, next_interval : Time::Span) do
          Log.error(exception: ex) do
            " ? An error occoured while executing request; retring (#{attempt}/10, next in: #{next_interval.to_f}s)"
          end
        end

      Retriable.retry(
        on: {
          Crest::RequestFailed,
          TikToker::RequestError,
          IO::Error,
          IO::TimeoutError,
          OpenSSL::SSL::Error,
          Socket::Addrinfo::Error,
          Socket::ConnectError,
        },
        on_retry: on_retry_callback,
        multiplier: 2.0,
      ) do
        yield
      end
    rescue ex : Crest::RequestFailed | TikToker::RequestError | IO::Error | IO::TimeoutError | OpenSSL::SSL::Error | Socket::Addrinfo::Error | Socket::ConnectError
      raise TikToker::RetriesExaustedError.new
    end
  end
end
