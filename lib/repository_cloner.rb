require 'rugged'

module AmandaBot
  class RepositoryCloner

    TMP_FOLDER = "/tmp/current_repository"

    def initialize( repository_name, branch )
      @repository_name = repository_name
      @branch = branch
    end

    def clone
      prepare_temp_folder
      Rugged::Repository.clone_at(@repository_name, 
                                  "#{TMP_FOLDER}/#{@repository_name}", 
                                  checkout_branch: @branch)
    end

    def prepare_temp_folder
      unless Dir["#{TMP_FOLDER}/*"].empty?
        FileUtils.rm_rf(Dir["#{TMP_FOLDER}/*"], secure: true)
      end
    end

  end
end