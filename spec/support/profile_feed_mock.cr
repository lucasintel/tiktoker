module ProfileFeedMock
  CURSORS = ["0", "1614377227000", "1611785532000"]

  # Naive user profile mock.
  def mock_profile_feed(sec_uid = "SecUID") : Nil
    CURSORS.each_with_index(1) do |cursor, page|
      request = TikToker::RequestBuilder.user_profile_feed(sec_uid, cursor)

      WebMock.stub(:post, "http://localhost:3000")
        .with(body: {url: request.to_s}.to_json)
        .to_return(status: 200, body: load_fixture("signed-request-page-#{page}"))

      WebMock.stub(:get, "https://MOCK_SIGNED_URL/#{page}")
        .to_return(status: 200, body: load_fixture("profile-feed-page-#{page}"))
    end
  end
end
