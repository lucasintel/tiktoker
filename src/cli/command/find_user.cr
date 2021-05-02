class TikToker::CLI
  struct Command::FindUser < Command
    @user_profile : TikTok::InitialProps

    def initialize(username)
      @user_profile = find_user(username)
    end

    def call
      user = @user_profile.user_info.user
      stats = @user_profile.user_info.stats
      videos = @user_profile.items

      user_info_table = Tallboy.table do
        header(
          String.build do |str|
            str << user.nickname.colorize.bold
            str << " [Verified]".colorize.bold if user.verified
            str << " [Private account]".colorize.bold if user.private_account
            str << '\n'
            str << '@'
            str << user.unique_id
          end
        )

        if user.signature.presence || user.bio_link.presence
          header(
            String.build do |str|
              if user.signature.presence
                str << user.signature
                str << '\n' if user.bio_link.presence
              end

              str << "[Bio Link] #{user.bio_link}" if user.bio_link.presence
            end
          )
        end

        header do
          cell "#{humanize(stats.following_count).colorize.bold} Following"
          cell "#{humanize(stats.follower_count).colorize.bold} Followers"
          cell "#{humanize(stats.heart).colorize.bold} Likes"
          cell "#{stats.video_count.colorize.bold} Videos"
        end
      end

      if videos.any?
        latest_uploads = Tallboy.table do
          columns do
            add "URL"
            add "Views"
            add "Likes"
            add "Comments"
          end

          header

          videos.each do |video|
            row [
              "https://www.tiktok.com/@#{user.unique_id}/video/#{video.video.id}",
              humanize(video.stats.play_count).colorize.bold,
              humanize(video.stats.digg_count).colorize.bold,
              humanize(video.stats.comment_count).colorize.bold,
            ]
          end
        end
      end

      main_table = CLI::InlineTable.with do
        add("SecUID", user.sec_uid)
        add("ID", user.id)
        add("Avatar", user.avatar_larger)
        if created_at = user.create_time
          add("Registered at", created_at.to_s("%A, %d %b %Y %H:%M"))
        end
        add("Comment settings", user.comment_setting)
        add("Duet settings", user.duet_setting)
        add("Stitch settings", user.stitch_setting)
      end

      STDOUT.puts(user_info_table.render)
      STDOUT.puts(latest_uploads.render) if videos.any? && latest_uploads
      STDOUT.puts(main_table.render)
    end

    private def find_user(username)
      TikToker.find_user(username)
    rescue ex : TikToker::UserNotFoundError | TikToker::RequestError
      print_exception(ex)
    end
  end
end
