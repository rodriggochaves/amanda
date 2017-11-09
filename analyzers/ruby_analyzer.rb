require 'rugged'
require_relative 'analyzer'
require_relative 'visitable'

class RubyAnalyzer < Analyzer
  include Visitable
  attr_reader :branch

  def initialize(repository, branch)
    super(repository)
    @branch = branch
  end

  def analyze
    repo = setup_repository
    author = setup_author
    # tree_builder = Rugged::Tree::Builder.new(repo)
    index = repo.index
    # all files
    run_rubocop(index, repo)
    commit_changes(author, index, repo)
    # Push Changes
    # remote = repo.remotes['origin']
    # credentials = Rugged::Credentials::UserPassword.new(username: ENV['GITHUB_LOGIN'],
    #                                                     password: ENV['GITHUB_PASSWORD'])
    # remote.push(["refs/heads/#{@branch}"], credentials: credentials)
  end

  def setup_repository
    repo = Rugged::Repository.new('./tmp')
  end

  def setup_author
    author = {email: "renan.lobato.rheinboldt@gmail.com", time: Time.now, name: "renanlr"}
  end

  def commit_changes(author, index, repo)
    index.write
    options = {}
    options[:tree] = index.write_tree(repo)
    options[:author] = author
    options[:committer] = author
    options[:message] = "Amanda checking some code smell"
    options[:parents] = repo.empty? ? [] : [repo.head.target].compact
    options[:update_ref] = 'HEAD'
    Rugged::Commit.create(repo, options)
  end

  def run_rubocop(index, repo)
    Dir["./tmp/**/*.rb"].each do |file|
      system "rubocop -a #{file}"
      repository_name = file.split("/").last
      oid = Rugged::Blob.from_workdir repo, repository_name
      index.add(:path => repository_name, :oid => oid, :mode => 0100644)
    end
  end
end