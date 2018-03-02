require 'rugged'
require 'fileutils'

module AmandaBot
  class RepositoryManager

    TMP_FOLDER = "./tmp/repositories"

    def initialize( repository_name, branch )
      @repository_name = repository_name
      @branch = branch
    end

    def clone
      prepare_temp_folder
      @repository = Rugged::Repository.clone_at("https://github.com/#{@repository_name}.git", 
                                  "#{TMP_FOLDER}/#{@repository_name}", 
                                  checkout_branch: @branch)
    end

    def prepare_temp_folder
      unless Dir["#{TMP_FOLDER}/*"].empty?
        ::FileUtils.rm_rf(Dir["#{TMP_FOLDER}/*"], secure: true)
      end
    end

    def diff left
      raise "Repository do not exist" unless @repository
      @repository.diff(left, @branch).deltas.map{ |delta| delta.new_file[:path] }
    end

    def setup_work_branch
      name = "amanda-checking-#{@branch}"
      @repository.create_branch(name)
      @repository.checkout(name)
    end

    def add_file_to_git_tree file
      file_name = File.basename(file)
      oid = Rugged::Blob.from_workdir @repository, file_name
      @repository.index.add(:path => file_name, :oid => oid, :mode => 0100644)
    end

    def setup_author
      {
        email: 'rodriggochaves@gmail.com',
        time: Time.now,
        name: 'rodriggochaves'
      }
    end

    def commit_changes
      @repository.index.write
      options = {
        tree: @repository.index.write_tree(@repository),
        author: setup_author,
        comitter: setup_author,
        message: 'Amanda checking some issues',
        parents: @repository.empty? ? [] : [@repository.head.target].compact,
        update_ref: 'HEAD',
      }
      Rugged::Commit.create(@repository, options)
    end

  end
end