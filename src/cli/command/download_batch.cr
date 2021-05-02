class TikToker::CLI
  struct Command::DownloadBatch < Command
    @file : String

    def initialize(@file)
    end

    def call
      extracted_sec_uids = CLI::FileProcessor.call(@file)
      if extracted_sec_uids.nil?
        STDERR.puts("ERROR: No such file or directory: #{@file}".colorize(:red).bold)
        exit(1)
      end

      if extracted_sec_uids.empty?
        STDERR.puts("ERROR: The file is empty!".colorize(:red).bold)
        exit(1)
      end

      TikToker::Downloader.download_users(extracted_sec_uids)
    end
  end
end
