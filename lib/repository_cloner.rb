require 'rugged'
require 'fileutils'

module AmandaBot
  class RepositoryCloner

    TMP_FOLDER = "./tmp/repositories"

    def initialize( repository_name, branch )
      @repository_name = repository_name
      @branch = branch
    end

    def clone
      prepare_temp_folder
      Rugged::Repository.clone_at("https://github.com/#{@repository_name}.git", 
                                  "#{TMP_FOLDER}/#{@repository_name}", 
                                  checkout_branch: @branch)
    end

    def prepare_temp_folder
      unless Dir["#{TMP_FOLDER}/*"].empty?
        ::FileUtils.rm_rf(Dir["#{TMP_FOLDER}/*"], secure: true)
      end
    end

  end
end