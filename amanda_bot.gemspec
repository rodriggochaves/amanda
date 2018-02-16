
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "amanda_bot/version"

Gem::Specification.new do |spec|
  spec.name          = "amanda_bot"
  spec.version       = AmandaBot::VERSION
  spec.authors       = ["Rodrigo A Chaves"]
  spec.email         = ["rodriggo.chaves@gmail.com"]

  spec.summary       = "A Bot that receives a pull request and runs a analyses on it"
  spec.homepage      = "https://github.com/rodriggochaves/amanda_bot"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rubocop", "~> 0.52.1"
  spec.add_dependency "dot_env", "~> 0.0.3"
  spec.add_dependency "octokit", "~> 4.7"
  spec.add_dependency "git_diff_parser", "~> 3.1.0"
  spec.add_dependency "rugged", "~> 0.26.0"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "byebug", "~> 10.0.0"
end
