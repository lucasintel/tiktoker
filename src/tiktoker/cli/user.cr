require "tallboy"

module TikToker
  class CLI::User < Admiral::Command
    define_argument user : String, required: true

    rescue_from Identifier::InvalidIdentifierError do |ex|
      print_exception(ex)
    end

    rescue_from TikToker::UserNotFoundError do |ex|
      print_exception(ex)
    end

    rescue_from TikToker::HTTPError do |ex|
      print_exception(ex)
    end

    def run
      identifier = Identifier.for(arguments.user)
      initial_props = TikToker::Client.find_user(identifier.name)

      # TODO: Create our own interface for tiktok responses.
      user = initial_props.user_info.user
      stats = initial_props.user_info.stats
      videos = initial_props.items

      user_info_table = Tallboy.table do
        header(
          String.build do |str|
            str << user.nickname.colorize.bold
            str << ' '
            str << "[verified]".colorize.bold if user.verified
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

              str << "Link: #{user.bio_link}" if user.bio_link.presence
            end
          )
        end

        header do
          cell "#{humanize(stats.following_count).colorize.bold} Following"
          cell "#{humanize(stats.follower_count).colorize.bold} Followers"
          cell "#{humanize(stats.heart_count).colorize.bold} Likes"
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
        add("Username", user.unique_id)
        add("Nickname", user.nickname)
        add("Avatar", user.avatar_larger)
        add("Private account", user.private_account)
        add("Verified", user.verified)
        add("Stat:Following", "#{humanize(stats.following_count)} Following")
        add("Stat:Followers", "#{humanize(stats.follower_count)} Followers")
        add("Stat:Likes", "#{humanize(stats.heart_count)} Likes")
        add("Stat:Videos", "#{stats.video_count} Videos")
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

    private def humanize(number)
      if number < 1000
        number.to_s
      else
        number.humanize
      end
    end

    private def print_exception(ex : Exception)
      STDERR.puts("ERROR: #{ex.message}".colorize(:red).bold)
      exit(1)
    end
  end
end

require "./user/*"
