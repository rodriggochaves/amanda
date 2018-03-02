require_relative '../lib/amanda_bot/repository_manager'
require 'rugged'

class RepositoryMock
  def diff left, right
    DiffMock.new
  end
end

class DiffMock
  def deltas
    [ DeltaMock.new(1), DeltaMock.new(2) ]
  end
end


class DeltaMock
  def initialize number
    @number = number
  end

  def new_file
    { path: "text#{@number}.txt" }
  end
end

RSpec.describe 'RepositoryManager can' do
  let(:repository_name) { "rodriggochaves/literate-lamp" }
  let(:branch) { "issue-3" }
  
  it "be instancieted" do
    expect{ AmandaBot::RepositoryManager.new( repository_name, branch ) }.to_not raise_error
  end

  describe ".prepare_temp_folder" do

    it "verify if the folder is empty" do
      spy = class_double(Dir)
        .as_stubbed_const(:transfer_nested_constants => true)
      expect(spy).to receive(:[]).with("./tmp/repositories/*").and_return([])
      cloner = AmandaBot::RepositoryManager.new( repository_name, branch )
      cloner.prepare_temp_folder
    end

    it "removes all files if isn't empty" do
      allow(Dir).to receive(:[]) { ["text1.txt", "text2.txt"] }
      spy = class_double(FileUtils)
        .as_stubbed_const(:transfer_nested_constants => true)
      expect(spy).to receive(:rm_rf).with(Dir["./tmp/repositories/*"], { secure: true })
      cloner = AmandaBot::RepositoryManager.new( repository_name, branch )
      cloner.prepare_temp_folder
    end
  end

  it "clones the repository" do
    allow(Dir).to receive(:[]) { [] }
    spy = class_double(Rugged::Repository)
      .as_stubbed_const(:transfer_nested_constants => true)
    expect(spy).to receive(:clone_at).with("https://github.com/rodriggochaves/literate-lamp.git",
                                           "./tmp/repositories/rodriggochaves/literate-lamp",
                                           { checkout_branch: branch })
    cloner = AmandaBot::RepositoryManager.new repository_name, branch
    cloner.clone
  end

  it ".diff" do
    manager = AmandaBot::RepositoryManager.new repository_name, branch
    manager.instance_variable_set(:@repository, RepositoryMock.new)
    expect(manager.diff("origin/master")).to match(["text1.txt", "text2.txt"])
  end


end