require "./../spec_helper"

describe TikToker::Configuration do
  describe "#with" do
    it "yields self" do
      instance = TikToker::Configuration.new
      instance.with do |config|
        config.tiktok_host = "random-host.com"
      end

      instance.tiktok_host.should eq("random-host.com")
    end
  end
end
