require "./../spec_helper"

describe TikToker::Util do
  describe "#build_profile_url" do
    it "builds the profile url" do
      TikToker::Util.build_profile_url("username")
        .should eq("https://www.tiktok.com/@username?lang=en")
    end

    it "allows overriding the default portal language" do
      TikToker::Util.build_profile_url("username", "de")
        .should eq("https://www.tiktok.com/@username?lang=de")
    end
  end

  describe "#did" do
    it "is a string of length 19" do
      did = TikToker::Util.generate_did
      did.size.should eq(19)
    end

    it "is only digits" do
      did = TikToker::Util.generate_did
      did.each_char do |char|
        char.ascii_number?.should be_true
      end
    end
  end
end
