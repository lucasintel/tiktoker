require "./../spec_helper"

describe TikToker::Request do
  it "instantiates with right path and query params" do
    request = TikToker::Request.new(
      path: "/api/post/item_list/",
      query: URI::Params.build do |query|
        query.add("secUid", "0x1111")
      end
    )

    request.build.should eq("https://www.tiktok.com/api/post/item_list/?secUid=0x1111")
  end

  describe "#add" do
    it "adds a query param to the request" do
      request = TikToker::Request.new("/api/post/item_list/")
      request.add("secUid", "0x1111")

      request.has_key?("secUid").should be_true
      request["secUid"].should eq("0x1111")
    end
  end

  describe "#build" do
    it "builds the request" do
      request = TikToker::Request.new("/api/post/item_list/")
      request.add("secUid", "0x1111")

      request.build.should eq("https://www.tiktok.com/api/post/item_list/?secUid=0x1111")
    end
  end

  describe "#to_s" do
    it "builds the request" do
      request = TikToker::Request.new("/api/post/item_list/")
      request.add("secUid", "0x1111")

      request.to_s.should eq("https://www.tiktok.com/api/post/item_list/?secUid=0x1111")
    end
  end
end
