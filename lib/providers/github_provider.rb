class GithubProvider

  def initialize
    @client = Octokit::Client.new( auth_information )
  end

  def auth_information
    {
      login: ENV['GITHUB_LOGIN'],
      password: ENV['GITHUB_PASSWORD']
    }
  end

  def create_pull_request base, head
    @client.create_pull_request( 'rodriggochaves/literate-lamp', base, head,
                                 'Amanda checking some code style' )
  end

end