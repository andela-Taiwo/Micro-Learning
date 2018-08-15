# Gemfile
source "https://rubygems.org"

# declare the sinatra dependency
gem "activerecord", "4.2.5"
gem "bcrypt", "~> 3.1.7"
gem "coveralls", require: false
gem "dotenv"
gem "foreman"
gem "pg", "~> 0.20.0"
gem "pony", "~> 1.6", ">= 1.6.1"
gem "rack-test"
gem "rake"
gem "redis"
gem "rufus-scheduler"
gem "sass"
gem "sidekiq"
gem "sidekiq-scheduler"
gem "sinatra"
gem "sinatra-activerecord"
gem "sinatra-assetpack"
gem "sinatra-flash", "~> 0.3.0"
gem "warden", "1.2.1"

group :development do
  gem "rubocop"
  gem "rubocop-airbnb"
  gem "shotgun"
end

group :test do
  gem "database_cleaner"
  gem "factory_bot", "~> 4.0", require: false
  gem "rspec"
  gem "rspec-sidekiq"
  gem "rspec_junit_formatter"
  gem "simplecov", require: false
  gem "simplecov-console"
  gem "simplecov-json", require: false
  gem "simplecov-rcov", require: false
  gem "sqlite3"
end
