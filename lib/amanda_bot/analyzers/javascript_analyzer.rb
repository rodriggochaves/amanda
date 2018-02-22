require_relative 'analyzer'
require_relative 'visitable'

class JavascriptAnalyzer < Analyzer
  include Visitable

  def analyze
    run_eslint
    commit_changes
    # Push Changes
    remote = @repo_reference.remotes['origin']
    credentials = Rugged::Credentials::UserPassword.new(username: ENV['GITHUB_LOGIN'],
                                                        password: ENV['GITHUB_PASSWORD'])
    remote.push(["refs/heads/#{@base_branch}"], credentials: credentials)
    client = ::Octokit::Client.new(:login => ENV['GITHUB_LOGIN'], :password => ENV['GITHUB_PASSWORD'])
    client.create_pull_request('rodriggochaves/literate-lamp', @branch, @base_branch, 
                                "Amanda checking some code smells")
  end

  def run_eslint
    @files.each do |file|
      tmp_file = "./tmp/#{file}"
      system "eslint -c ~/.eslintrc.js #{tmp_file} --fix"
      add_file_to_git_tree(file)
    end
  end
end