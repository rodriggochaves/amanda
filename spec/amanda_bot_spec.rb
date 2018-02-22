require_relative 'mocks/octokit_mock'

include LanguageSelector

RSpec.describe AmandaBot do
  it "has a version number" do
    expect(AmandaBot::VERSION).not_to be nil
  end

  it "can be instantiated" do
    expect{ AmandaBot::Amanda.new(OctokitMock.new) }.to_not raise_error
  end

  describe "can parse language params" do
    it "with 2 params" do
      result = LanguageSelector::parse_params("-R -J")
      expect(result).to eq(["R", "J"])
    end
  end
end
