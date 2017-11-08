require 'rubocop'
require 'dot_env'
require 'octokit'
require 'pp'
require 'git_diff_parser'
require 'rugged'
require 'fileutils'

DotEnv.get_environment

def delete_tmp
  if File.directory?("./tmp")
    FileUtils.rm_rf './tmp'
  end
end

class Amanda
  def initialize

    Octokit.configure do |c|
      c.login = ENV['GITHUB_LOGIN']
      c.password = ENV['GITHUB_PASSWORD']
    end

    name = 'rodriggochaves/literate-lamp'

    pull_requests = Octokit.pull_requests(name, status: 'open')[0]

    head_branch = pull_requests[:head][:ref]

    delete_tmp

    # things to do
    # 1 - mudar a branch para a branch alvo
    Rugged::Repository.clone_at("https://github.com/rodriggochaves/literate-lamp.git", "./tmp", {
      transfer_progress: lambda { |total_objects, indexed_objects,
                                    received_objects, local_objects, total_deltas, indexed_deltas, received_bytes|
      pp total_objects, received_objects}, checkout_branch: head_branch } )

    # Octokit.configure do |c|
    #   c.login = ENV['GITHUB_LOGIN']
    #   c.password = ENV['GITHUB_PASSWORD']
    # end
    #
    # name = 'rodriggochaves/literate-lamp'
    #
    #
    # pull_requests = Octokit.pull_requests(name, status: 'open')[0]
    #
    #
    # head_sha = pull_requests[:head][:sha]
    #
    # files = Octokit.pull_request_files(name, 3)
    #
    # pp files
    # example = files[0]
    # # commit = Octokit.commit(name, head_sha)
    #
    # patch = GitDiffParser::Patch.new(example[:patch])
    #
    # cop = RuboCop::Cop::Style::StringLiterals
    # team = RuboCop::Cop::Team.new(RuboCop::Cop::Registry.new([cop]),
    #                               RuboCop::ConfigLoader.default_configuration,
    #                               {auto_correct: true})
    # patch.changed_lines.each do |l|
    #   pp team.auto_correct(l.content, [cop])
    # end



    

    # usar o octokit para recuperar os arquivos
    # usar o metodo .inspect_file
  end
end