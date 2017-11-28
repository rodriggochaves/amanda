require 'rubocop'
require 'octokit'
require 'pp'
require 'git_diff_parser'
require 'fileutils'
require 'byebug'
require_relative 'language_selector'
require_relative 'analyzers/ruby_analyzer'
require_relative 'visitors/analyze_visitor'

class Amanda
  include LanguageSelector

  def initialize(repository_name, repository_language)
    @repository_name = repository_name
    repository_full_name = "https://github.com/#{repository_name}.git"
    configure_octokit_credentials
    current_pull_request = get_pull_request(repository_name)
    files_changed = get_files_changed(current_pull_request)
    head_branch = current_pull_request[:head][:ref]
    analyze_code_style(head_branch, files_changed, repository_full_name, repository_language)
  end

  def get_files_changed(pr)
    files_changed = Octokit.pull_request_files(@repository_name, pr[:number])
    files_changed.map{ |e| e[:filename] }
  end

  def get_pull_request(repository_name)
    # here goes some fancy logic to improve the pull request selection
    Octokit.pull_requests(repository_name, status: 'open')[0]
  end

  def analyze_code_style(head_branch, files, repository_full_name, repository_language)
    analyzer = create_analyzer(repository_full_name, files, repository_language, head_branch)
    analyzer.accept(AnalyzeVisitor.new)
  end

  def configure_octokit_credentials
    Octokit.configure do |c|
      c.login = ENV['GITHUB_LOGIN']
      c.password = ENV['GITHUB_PASSWORD']
    end
  end

end