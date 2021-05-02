require "./downloader/*"

module TikToker
  module Downloader
    Log = ::Log.for(self)

    # Iterates through the *sec_uid* profile feed from the current *cursor* to
    # the oldest post, downloading all posts it can find.
    def self.download_user(sec_uid : SecUID, cursor : String = "0") : Nil
      Log.info(&.emit("Collecting videos from user feed", sec_uid: sec_uid))

      collector = TikToker::ProfileIterator.new(sec_uid, cursor)
      collector.each_post do |post|
        downloaded = VideoDownloader.new(post).call

        if TikToker.config.fast_update && !downloaded
          Log.info { "✅ User in sync!" }
          return
        end
      end
    rescue ex : TikToker::NoPostsError
      Log.error { " ! TikTok API returned an empty collector; skipping" }
    end

    def self.download_users(sec_uids : Array(SecUID)) : Nil
      sec_uids.each do |sec_uid|
        download_user(sec_uid)
        Log.info { }
      end
    end
  end
end
