ENV['RAILS_ENV'] ||= 'test'

if ENV['COVERAGE']
  require 'simplecov'
  require_relative './simplecov'
end

require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  include AuthHelper
  include ActionMailer::TestHelper
  include FactoryBot::Syntax::Methods

  # Run tests in parallel with specified workers
  # Disable parallelization when measuring coverage to get consistent results
  ENV['COVERAGE'] || parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
