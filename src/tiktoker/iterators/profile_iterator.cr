module TikToker
  # A `ProfileIterator` allows iterating a `TikTok::UserProfile` by page.
  #
  # For example:
  #
  # ```
  # iterator = TikToker::ProfileIterator.new("SecUID", "0")
  # iterator.next # => Page 1
  # iterator.next # => Page 2
  # iterator.next # => Iterator::Stop
  # ```
  #
  # Most of the time, what you really want is to iterate through the posts
  # without having to worry about pagination. See `#each_post`.
  #
  # ```
  # iterator = TikToker::ProfileIterator.new("SecUID", "0")
  # iterator.each_post do |post|
  #   post # => TikTok::Post
  # end
  # ```
  class ProfileIterator
    include Iterator(TikTok::Post)

    # Returns the secUid of the owner of the profile being iterated through.
    getter sec_uid : SecUID

    # Returns the current cursor position of the iterator.
    getter cursor : String

    def initialize(@sec_uid, @cursor)
      @end = false
    end

    # Fetches the next page from the user profile, and updates the cursor
    # position. Raises `TikToker::NoPostsError` if TikTok API returns no posts
    # for the given *sec_uid*.
    #
    # ```
    # iterator = TikToker::ProfileIterator.new(SEC_UID, "0")
    # iterator.cursor # => "0"
    # iterator.next   # => Array(TikTok::Post)
    # iterator.cursor # => "1614377227000"
    # ```
    def next
      return stop if @end

      collection = Util.retry_on_connection_error do
        TikToker.user_profile_feed(@sec_uid, @cursor)
      end

      if item_list = collection.item_list
        @cursor = collection.cursor
        @end = !collection.has_more

        if item_list.any?
          item_list
        else
          stop
        end
      else
        raise NoPostsError.new("TikTok API returned no posts for this user")
      end
    end

    # Yields successive posts from the user profile. It iterates through all
    # pages from the current cursor to the oldest post.
    #
    # ```
    # iterator = TikToker::ProfileIterator.new(SEC_UID, "0")
    # iterator.each_post do |post|
    #   post # => TikTok::Post
    # end
    # ```
    def each_post
      each do |collection|
        collection.each do |post|
          yield(post)
        end
      end
    end

    # Returns `true` until the iterator receives a TikTok response indicating
    # that the user profile has been fully iterated over.
    #
    # ```
    # iterator = TikToker::ProfileIterator.new(SEC_UID, "0")
    # iterator.has_more? # => true
    # iterator.next      # => TikTok::PostCollection
    # iterator.has_more? # => false
    # iterator.next      # => Iterator::Stop
    # ```
    def has_more?
      !@end
    end
  end
end
