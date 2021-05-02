require "./../../spec_helper"

describe TikToker::RequestSigner::External do
  describe "#call" do
    it "signs the request" do
      request = TikToker::Request.new("/")

      WebMock.stub(:post, "http://localhost:3000")
        .with(body: {url: request.to_s}.to_json)
        .to_return(status: 200, body: load_fixture("signed-request-page-1"))

      signature = TikToker::RequestSigner::External.new(request).call

      signature.should be_a(TikToker::SignedRequest)
      signature.signed_at.should eq(Time.unix_ms(1619243209467))
      signature.signature.should eq("MOCKED_SIGNATURE")
      signature.verify_fp.should eq("MOCKED_VERIFYFP")
      signature.signed_url.should eq("https://MOCK_SIGNED_URL/1")
      signature.navigator.user_agent.should eq("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (Windows NT 10.0; Win64; x64) Chrome/88.0.4324.96 Safari/537.36")
      signature.navigator.browser_name.should eq("Mozilla")
      signature.navigator.browser_version.should eq("5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (Windows NT 10.0; Win64; x64) Chrome/88.0.4324.96 Safari/537.36")
      signature.navigator.browser_language.should eq("en-US")
      signature.navigator.browser_platform.should eq("Win32")
      signature.navigator.screen_width.should eq(1920)
      signature.navigator.screen_height.should eq(1080)
    end
  end
end
