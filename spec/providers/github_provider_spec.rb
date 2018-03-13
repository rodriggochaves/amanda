require_relative '../../lib/providers/github_provider'

RSpec.describe GithubProvider do
  
  it 'load user information' do
    allow(ENV).to receive(:[]).with('GITHUB_LOGIN').and_return("me@amandabot.com")
    allow(ENV).to receive(:[]).with('GITHUB_PASSWORD').and_return("asdfqwer")

    github_provider = GithubProvider.new
    expect(github_provider.auth_information).to eq({
      login: 'me@amandabot.com',
      password: 'asdfqwer'
    })
  end

  it 'have a octokit client' do
    allow(Octokit::Client).to receive(:new)
    github_provider = GithubProvider.new
    expect(Octokit::Client).to have_received(:new)
  end

  it 'can create a new pull request' do
    
    allow_any_instance_of(Octokit::Client::PullRequests).to receive(:create_pull_request)
      .and_raise(Exception)

    allow_any_instance_of(Octokit::Client::PullRequests).to receive(:create_pull_request)
      .with("rodriggochaves/literate-lamp", "master", "issue-4",
            "Amanda checking some code style" )
      .and_return(nil)

    github_provider = GithubProvider.new
    expect{ github_provider.create_pull_request( "master", "issue-4" ) }.to_not raise_error
    
  end

end