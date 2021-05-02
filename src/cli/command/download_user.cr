class TikToker::CLI
  struct Command::DownloadUser < Command
    @username : String

    def initialize(@username)
    end

    def call
      TikToker::Downloader.download_users([@username])
    end
  end
end
