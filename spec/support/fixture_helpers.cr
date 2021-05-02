module FixtureHelpers
  def load_fixture(name : String?) : String
    case name
    when String
      File.read("#{fixtures_path}/#{name}.json")
    else
      ""
    end
  end

  def fixtures_path : String
    File.expand_path("../../fixtures", __FILE__)
  end
end
