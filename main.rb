require 'pry'
require 'byebug'
Dir['./lib/**/*.rb'].each { |f| require_relative(f) }

amanda = AmandaBot::Amanda.new "rodriggochaves/literate-lamp", AmandaBot::Amanda.test_options
amanda.setup_repository
amanda.run "--ruby"