require "amanda_bot/version"
require 'octokit'
require 'git_diff_parser'
require 'fileutils'
require_relative 'amanda_bot/language_selector'
require_relative 'amanda_bot/analyzers/ruby_analyzer'
require_relative 'amanda_bot/visitors/analyze_visitor'

module AmandaBot
  class Amanda
    include LanguageSelector

    def initialize
      ::Octokit.configure do |c|
        c.login = ENV['GITHUB_LOGIN']
        c.password = ENV['GITHUB_PASSWORD']
      end

    def setup_repository
      @repository = AmandaBot::RepositoryManager.new( @repository_name, @head_branch )
      @repository.clone
      @repository.setup_work_branch
    end

    def run(repository_name, repository_language)
      @repository_name = repository_name
      repository_full_name = "https://github.com/#{repository_name}.git"
      current_pull_request = get_pull_request(repository_name)
      files_changed = get_files_changed(current_pull_request)
      head_branch = current_pull_request[:head][:ref]
      analyze_code_style(head_branch, files_changed, repository_full_name, repository_language)
    end

    def get_files_changed(pr)
      files_changed = ::Octokit.pull_request_files(@repository_name, pr[:number])
      files_changed.map{ |e| e[:filename] }
    end

    def get_pull_request(repository_name)
      # here goes some fancy logic to improve the pull request selection
      ::Octokit.pull_requests(repository_name, status: 'open')[0]
    end

    def analyze_code_style(head_branch, files, repository_full_name, repository_language)
      analyzer = create_analyzer(repository_full_name, files, repository_language, head_branch)
      analyzer.accept(AnalyzeVisitor.new)
    end

  end
end
