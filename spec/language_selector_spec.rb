require_relative '../lib/amanda_bot/language_selector'
require_relative '../lib/amanda_bot/analyzers/ruby_analyzer'
require_relative '../lib/amanda_bot/analyzers/javascript_analyzer'

RSpec.describe 'Language selector can' do

  let(:options) { "--ruby --javascript" }

  it "parse a string and return the corresponding tokens" do
    expect(AmandaBot::LanguageSelector.parse(options)).to eq([:ruby, :javascript])
  end

  it "returns a list of Analyzers" do
    analyzers = AmandaBot::LanguageSelector.analyzers("rodriggochaves/literate-lamp", options)
    expect(analyzers.map{ |a| a.class}).to match([ RubyAnalyzer, JavascriptAnalyzer ])
  end

end