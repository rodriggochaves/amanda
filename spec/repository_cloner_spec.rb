require_relative '../lib/repository_cloner'
require 'rugged'

RSpec.describe 'cloning a repository' do
  let(:repository_name) { "rodriggochaves/literate-lamp" }
  let(:branch) { "issue-3" }
  
  it "can be instancieted" do
    expect{ AmandaBot::RepositoryCloner.new( repository_name, branch ) }.to_not raise_error
  end

  describe "prepare_temp_folder" do

    it "verify if the folder is empty" do
      spy = class_double(Dir)
        .as_stubbed_const(:transfer_nested_constants => true)
      expect(spy).to receive(:[]).with("/tmp/current_repository/*").and_return([])
      cloner = AmandaBot::RepositoryCloner.new( repository_name, branch )
      cloner.prepare_temp_folder
    end

    it "removes all files if isn't empty" do
      allow(Dir).to receive(:[]) { ["text1.txt", "text2.txt"] }
      spy = class_double(FileUtils)
        .as_stubbed_const(:transfer_nested_constants => true)
      expect(spy).to receive(:rm_rf).with(Dir["/tmp/current_repository/*"], { secure: true })
      cloner = AmandaBot::RepositoryCloner.new( repository_name, branch )
      cloner.prepare_temp_folder
    end
  end

  it "clones the repository" do
    allow(Dir).to receive(:[]) { [] }
    spy = class_double(Rugged::Repository)
      .as_stubbed_const(:transfer_nested_constants => true)
    expect(spy).to receive(:clone_at).with("rodriggochaves/literate-lamp",
                                           "/tmp/current_repository/rodriggochaves/literate-lamp",
                                           { checkout_branch: branch })
    cloner = AmandaBot::RepositoryCloner.new repository_name, branch
    cloner.clone
  end

end