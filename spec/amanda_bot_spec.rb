RSpec.describe AmandaBot do
  it "has a version number" do
    expect(AmandaBot::VERSION).not_to be nil
  end

  it "does something useful" do
    amanda = AmandaBot::Amanda.new("rodriggochaves/literate_lamp", "-r")
    expect(amanda).to_not eq(nil)
  end
end
