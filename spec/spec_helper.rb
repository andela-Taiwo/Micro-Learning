ENV["RACK_ENV"] ||= "test"
require "coveralls"
Coveralls.wear!


require "simplecov"
require "simplecov-json"
require "simplecov-rcov"
require "simplecov-console"

SimpleCov.start

require "rack/test"
require "rspec"
require "rspec-sidekiq"
require "warden"
require "database_cleaner"
require "sidekiq/testing"
require "factory_bot"
require_relative "./helpers/controller_helper"

require File.expand_path "../../app/app.rb", __FILE__

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
  config.before(:each) do
    Sidekiq::Worker.clear_all
  end
  config.include FactoryBot::Syntax::Methods
  config.include Helpers::Controllers

  after { Warden.test_reset! }

  config.before(:suite) do
    FactoryBot.find_definitions
  end
  config.expect_with(:rspec) {|c| c.syntax = [:should, :expect] }

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
  config.shared_context_metadata_behavior = :apply_to_host_groups
end

RSpec::Sidekiq.configure do |config|
  # Clears all job queues before each example
  config.clear_all_enqueued_jobs = true # default => true
  # Whether to use terminal colours when outputting messages
  config.enable_terminal_colours = true # default => true
  # config.redis = { url: ENV.fetch('REDIS_URL') }

  # Warn when jobs are not enqueued to Redis but to a job array
  config.warn_when_jobs_not_processed_by_sidekiq = false # default => true
end
