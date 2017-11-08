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

    repo = Rugged::Repository.new('./tmp')

    author = { email: "rodriggochaves@gmail.com", time: Time.now, name: "rodriggochaves" }
    # tree_builder = Rugged::Tree::Builder.new(repo)
    index = repo.index

    # all files
    Dir["./tmp/**/*.rb"].each do |file|
      system "rubocop -a #{file}"
      name = file.split("/").last
      oid = Rugged::Blob.from_workdir repo, name
      index.add(:path => name, :oid => oid, :mode => 0100644) 
    end

    index.write()

    options = {}
    options[:tree] = index.write_tree(repo)

    options[:author] = author
    options[:committer] = author
    options[:message] =  "Amanda checking some code smell"
    options[:parents] = repo.empty? ? [] : [ repo.head.target ].compact
    options[:update_ref] = 'HEAD'

    Rugged::Commit.create(repo,options)
    

    # usar o octokit para recuperar os arquivos
    # usar o metodo .inspect_file
  end
end