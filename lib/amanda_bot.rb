require 'octokit'
require 'git_diff_parser'
require 'fileutils'
require 'json'
require 'byebug'
require_relative "amanda_bot/version"
require_relative 'amanda_bot/language_selector'
require_relative 'amanda_bot/analyzers/ruby_analyzer'
require_relative 'amanda_bot/visitors/analyze_visitor'
require_relative 'amanda_bot/repository_manager'

module AmandaBot
  class Amanda
    def initialize( repository_name, pull_request_event )
      @repository_name = repository_name
      @pull_request_event = deep_symbolize_keys(pull_request_event)
      @base_branch = @pull_request_event[:base][:ref]
      @head_branch = @pull_request_event[:head][:ref]
    end

    def run params
      setup_repository
      analyzers(params).each do |analyzer|
        files_changed = @repository.diff("origin/#{@base_branch}")
        changes = analyzer.accept(AnalyzeVisitor.new, files_changed)
        changes.each{ |c| @repository.add_file_to_git_tree(c) }
        @repository.commit_changes
      end
      @repository.push 
    end

    def setup_repository
      @repository = AmandaBot::RepositoryManager.new( @repository_name, @head_branch )
      @repository.clone
      @repository.setup_work_branch
    end

    def analyzers params
      AmandaBot::LanguageSelector.analyzers @repository_name, params
    end

    def files_changed
      @repository.diff( "origin/#{@base_branch}" )
    end

    def self.test_options
      {
        base: { ref: "master" },
        head: { ref: "issue-3" }
      }
    end

    private def deep_symbolize_keys h
      ::JSON.parse(::JSON[h], symbolize_names: true)
    end

  end
end
