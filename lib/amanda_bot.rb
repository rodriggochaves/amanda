require "amanda_bot/version"
require 'octokit'
require 'git_diff_parser'
require 'fileutils'
require_relative 'amanda_bot/language_selector'
require_relative 'amanda_bot/analyzers/ruby_analyzer'
require_relative 'amanda_bot/analyzers/javascript_analyzer'
require_relative 'amanda_bot/visitors/analyze_visitor'

module AmandaBot
  class Amanda
    include LanguageSelector

    def initialize(octokit)
      @octokit = octokit
      @octokit.configure do |c|
        c.login = ENV['GITHUB_LOGIN']
        c.password = ENV['GITHUB_PASSWORD']
      end
    end

    def run(repository_name, repository_language)
      @repository_name = repository_name
      repository_full_name = "https://github.com/#{repository_name}.git"
      current_pull_request = get_pull_request(repository_name)
      files_changed = get_files_changed(current_pull_request)
      head_branch = current_pull_request[:head][:ref]
      unless head_branch.include?("amanda-checking")
        analyze_code_style(head_branch, files_changed, repository_full_name, repository_language)  
      end
    end

    def get_files_changed(pr)
      files_changed = @octokit.pull_request_files(@repository_name, pr[:number])
      files_changed.map{ |e| e[:filename] }
    end

    def get_pull_request(repository_name)
      @octokit.pull_requests(repository_name, status: 'open')[0]
    end

    def analyze_code_style(head_branch, files, repository_full_name, repository_language)
      analyzers = create_analyzers(repository_full_name, files, repository_language, head_branch)
      analyzers.each{ |a| a.accept(AnalyzeVisitor.new) }
    end

    def self.create
      self.new(Octokit)
    end
  end
end
