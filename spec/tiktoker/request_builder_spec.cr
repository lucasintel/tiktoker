require "./../spec_helper"

describe TikToker::RequestBuilder do
  describe "#user_profile" do
    it "builds the request" do
      request = TikToker::RequestBuilder.user_profile_feed("0x1111", "0")

      request.uri.path.should eq("/api/post/item_list/")

      request["aid"].should eq("1988")
      request["did"].should match(/\d{19}/)
      request["secUid"].should eq("0x1111")
      request["count"].should eq("30")
      request["cursor"].should eq("0")
    end
  end

  describe "#search_user" do
    it "builds the request" do
      request = TikToker::RequestBuilder.search_user("charli", "0")

      request.uri.path.should eq("/api/search/user/full/")

      request["aid"].should eq("1988")
      request["device_id"].should match(/\d{19}/)
      request["keyword"].should eq("charli")
      request["cursor"].should eq("0")
    end
  end
end
