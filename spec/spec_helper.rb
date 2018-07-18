ENV['RACK_ENV'] ||= 'test'

require 'rack/test'
require 'rspec'
require 'database_cleaner'
require_relative '../app/helpers/test_helper'
require 'factory_bot'

require File.expand_path '../../app/app.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods

  def app
    described_class
  end
end

RSpec.configure do |config|
  config.include RSpecMixin
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  # config.before(:suite) do
  #   DatabaseCleaner.strategy = :transaction
  #   DatabaseCleaner.clean_with(:truncation)
  # end
  #
  # config.before(:each) do
  #   DatabaseCleaner.start
  # end
  # config.after(:each) do
  #   DatabaseCleaner.clean
  # end
  config.include Warden::Test::Helpers
  config.include FactoryBot::Syntax::Methods

  after { Warden.test_reset! }

  config.before(:suite) do
    FactoryBot.find_definitions
  end

  config.expect_with(:rspec) { |c| c.syntax = [:should, :expect] }

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
