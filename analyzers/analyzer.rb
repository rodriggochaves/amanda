require 'rugged'
require 'dot_env'

DotEnv.get_environment

class Analyzer
  attr_reader :repository
  attr_reader :branch
  attr_reader :email
  attr_reader :username
  attr_reader :repo_reference
  attr_reader :index_reference


  def initialize(repo, branch)
    @repository = repo
    @branch = branch
    @email = "renan.lobato.rheinboldt@gmail.com"
    @username = "renanlr"
    clone_repository
    setup_repository
  end

  def accept(visitor)
    raise NotImplementedError
  end

  def analyze
    raise NotImplementedError
  end

  private

  def setup_repository
    @repo_reference = Rugged::Repository.new('./tmp')
    @index_reference = @repo_reference.index
  end

  def setup_author
    {email: @email, time: Time.now, name: @username}
  end

  def commit_changes
    @index_reference.write
    options = {}
    options[:tree] = @index_reference.write_tree(@repo_reference)
    options[:author] = setup_author
    options[:committer] = setup_author
    options[:message] = "Amanda checking some code smell"
    options[:parents] = @repo_reference.empty? ? [] : [@repo_reference.head.target].compact
    options[:update_ref] = 'HEAD'
    Rugged::Commit.create(@repo_reference, options)
  end

  def clone_repository
    delete_tmp_folder
    Rugged::Repository.clone_at(@repository, './tmp', checkout_branch: @branch)
  end

  def add_file_to_git_tree(file_name)
    oid = Rugged::Blob.from_workdir @repo_reference, file_name
    @index_reference.add(:path => file_name, :oid => oid, :mode => 0100644)
  end

  def delete_tmp_folder
    if File.directory?("./tmp")
      FileUtils.rm_rf './tmp'
    end
  end
end