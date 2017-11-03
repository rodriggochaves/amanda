require 'rubocop'
require 'dot_env'
require 'octokit'
require 'pp'
require 'git_diff_parser'

DotEnv.get_environment

class Amanda
  def initialize
    Octokit.configure do |c|
      c.login = ENV['GITHUB_LOGIN']
      c.password = ENV['GITHUB_PASSWORD']
    end

    name = 'rodriggochaves/literate-lamp'


    pull_requests = Octokit.pull_requests(name, status: 'open')[0]


    head_sha = pull_requests[:head][:sha]

    files = Octokit.pull_request_files(name, 3)

    pp files
    example = files[0]
    # commit = Octokit.commit(name, head_sha)

    patch = GitDiffParser::Patch.new(example[:patch])

    cop = RuboCop::Cop::Style::StringLiterals
    team = RuboCop::Cop::Team.new(RuboCop::Cop::Registry.new([cop]),
                                  RuboCop::ConfigLoader.default_configuration,
                                  {auto_correct: true})
    patch.changed_lines.each do |l|
      pp team.auto_correct(l.content, [cop])
    end

    

    # usar o octokit para recuperar os arquivos
    # usar o metodo .inspect_file
  end
end