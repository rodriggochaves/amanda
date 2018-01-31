RSpec.describe AmandaBot do
  it "has a version number" do
    expect(AmandaBot::VERSION).not_to be nil
  end

  it "can be instantiated" do
    expect{ AmandaBot::Amanda.new }.to_not raise_error
  end
end
