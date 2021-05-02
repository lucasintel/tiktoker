require "./../../spec_helper"

describe TikToker::ProfileIterator do
  describe "#next" do
    it "iterates through the user profile" do
      mock_profile_feed

      iterator = TikToker::ProfileIterator.new("SecUID", "0")

      iterator.has_more?.should be_true
      iterator.cursor.should eq("0")

      # Page 1
      collection = iterator.next.as(Array(TikToker::TikTok::Post))
      collection.first.id.should eq("6942244238574816518")
      collection.last.id.should eq("6933697342528900358")

      iterator.has_more?.should be_true
      iterator.cursor.should eq("1614377227000")

      # Page 2
      collection = iterator.next.as(Array(TikToker::TikTok::Post))
      collection.first.id.should eq("6933695489229589765")
      collection.last.id.should eq("6922566098730716422")

      iterator.has_more?.should be_true
      iterator.cursor.should eq("1611785532000")

      # Page 3
      collection = iterator.next.as(Array(TikToker::TikTok::Post))
      collection.first.id.should eq("6921913201600777477")
      collection.last.id.should eq("6909922388482247942")

      iterator.has_more?.should be_false

      iterator.next.should be_a(Iterator::Stop)
    end

    it "iterates through an empty profile" do
      WebMock.stub(:post, "http://localhost:3000")
        .to_return(status: 200, body: load_fixture("signed-request-page-1"))

      WebMock.stub(:get, "https://MOCK_SIGNED_URL/1")
        .to_return(status: 200, body: load_fixture("profile-feed-no-videos"))

      iterator = TikToker::ProfileIterator.new("SecUID", "0")

      expect_raises(TikToker::NoPostsError) do
        iterator.next
      end
    end
  end

  describe "#each_post" do
    it "iterates through the user profile" do
      mock_profile_feed

      post_ids = [] of String

      iterator = TikToker::ProfileIterator.new("SecUID", "0")
      iterator.each_post do |post|
        post_ids << post.id
      end

      post_ids.size.should eq(90)
      post_ids.first.should eq("6942244238574816518")
      post_ids.last.should eq("6909922388482247942")
    end

    it "iterates through an empty profile" do
      WebMock.stub(:post, "http://localhost:3000")
        .to_return(status: 200, body: load_fixture("signed-request-page-1"))

      WebMock.stub(:get, "https://MOCK_SIGNED_URL/1")
        .to_return(status: 200, body: load_fixture("profile-feed-no-videos"))

      iterator = TikToker::ProfileIterator.new("SecUID", "0")

      expect_raises(TikToker::NoPostsError) do
        iterator.each_post do |post|
          # noop
        end
      end
    end
  end

  describe "#sec_uid" do
    it "returns the secUid of the owner of the profile being iterated" do
      iterator = TikToker::ProfileIterator.new("SecUID", "0")

      iterator.sec_uid.should eq("SecUID")
    end
  end

  describe "#cursor" do
    it "returns the current cursor position of the iterator" do
      iterator = TikToker::ProfileIterator.new("SecUID", "11111")

      iterator.cursor.should eq("11111")
    end
  end
end
