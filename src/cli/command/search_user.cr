class TikToker::CLI
  struct Command::SearchUser < Command
    @search : TikTok::SearchResult

    def initialize(username, cursor = "0")
      @search = search_user(username, cursor)
    end

    def call
      if @search.user_list.try(&.empty?)
        STDERR.puts("ERROR: No users found for criteria.".colorize(:red).bold)
        exit(1)
      end

      main_table = Tallboy.table do
        columns do
          add "Username"
          add "Nickname"
          add "Followers"
          add "Verified"
        end

        header

        @search.user_list.each do |user|
          row [
            user.unique_id.colorize.bold,
            user.nickname,
            humanize(user.follower_count).colorize.bold,
            !!user.custom_verify.presence,
          ]
        end
      end

      STDOUT.puts(main_table.render)
    end

    private def search_user(username, cursor)
      TikToker.search_user(username, cursor)
    rescue ex : TikToker::UserNotFoundError | TikToker::RequestError
      print_exception(ex)
    end
  end
end
