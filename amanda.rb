require 'rubocop'
require 'octokit'
require 'pp'
require 'git_diff_parser'
require 'fileutils'
require_relative 'language_selector'
require_relative 'analyzers/ruby_analyzer'
require_relative 'visitors/analyze_visitor'

class Amanda
  include LanguageSelector

  def initialize(repository_name, repository_language)
    repository_full_name = "https://github.com/"+repository_name+".git"
    head_branch = get_head_branch_of_pull_request(repository_name)
    analyze_code_style(head_branch, repository_full_name, repository_language)
  end

  def analyze_code_style(head_branch, repository_full_name, repository_language)
    analyzer = create_analyzer(repository_full_name, repository_language, head_branch)
    analyzer.accept(AnalyzeVisitor.new)
  end

  def get_head_branch_of_pull_request(repository_name)
    configure_octokit_credentials
    pull_requests = Octokit.pull_requests(repository_name, status: 'open')[0]
    pull_requests[:head][:ref]
  end

  def configure_octokit_credentials
    Octokit.configure do |c|
      c.login = ENV['GITHUB_LOGIN']
      c.password = ENV['GITHUB_PASSWORD']
    end
  end

end