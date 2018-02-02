require_relative 'analyzer'
require_relative 'visitable'

class RubyAnalyzer < Analyzer
  include Visitable

  def analyze
    run_rubocop
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

  def run_rubocop
    # run in all files
    @files.map{ |e| "./tmp/#{e}" }.each do |file|
      system "rubocop -a #{file}"
      file_name = File.basename(file)
      add_file_to_git_tree(file_name)
    end
  end
end