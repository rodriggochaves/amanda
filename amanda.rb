require 'rubocop'
require 'dot_env'
require 'octokit'
require 'pp'
require 'git_diff_parser'
require 'fileutils'
require_relative 'analyzers/ruby_analyzer'
require_relative 'visitors/analyze_visitor'
require_relative 'visitors/clone_repository_visitor'

DotEnv.get_environment

def delete_tmp
  if File.directory?("./tmp")
    FileUtils.rm_rf './tmp'
  end
end

class Amanda
  def initialize(repository_language)

    Octokit.configure do |c|
      c.login = ENV['GITHUB_LOGIN']
      c.password = ENV['GITHUB_PASSWORD']
    end

    repository_name = 'rodriggochaves/literate-lamp'
    repository_full_name = "https://github.com/"+repository_name+".git"

    pull_requests = Octokit.pull_requests(repository_name, status: 'open')[0]

    head_branch = pull_requests[:head][:ref]

    analyzer = create_analyzer(repository_full_name, repository_language, head_branch)

    delete_tmp

    analyzer.accept(CloneRepositoryVisitor.new)
    analyzer.accept(AnalyzeVisitor.new)


  end

  def create_analyzer(repository_full_name, repository_language, head_branch)
    case repository_language
      when "-R"
        RubyAnalyzer.new(repository_full_name, head_branch)
      else
        nil
    end
  end
end