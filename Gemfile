# Gemfile
source 'https://rubygems.org'

# declare the sinatra dependency
gem 'activerecord', '4.2.5'
gem 'bcrypt', '~> 3.1.7'
gem 'coveralls', require: false
gem 'dotenv'
gem "foreman"
gem 'pg', '~> 0.20.0'
gem 'pony', '~> 1.6', '>= 1.6.1'
gem 'sinatra-activerecord'
gem 'rack-test'
gem 'rake'
gem 'rufus-scheduler'
gem 'sass'
gem 'sidekiq'
gem 'sidekiq-scheduler'
gem 'sinatra'
gem 'sinatra-flash', '~> 0.3.0'
gem 'sinatra-assetpack'
gem 'redis'
gem "warden", "1.2.1"


group :development do
  gem 'shotgun'
  gem 'rubocop'
end

group :test do
  gem 'sqlite3'
  gem  'rspec'
  gem "rspec_junit_formatter"
  gem 'database_cleaner'
  gem 'rspec-sidekiq'
  gem 'simplecov', require: false
  gem "factory_bot", "~> 4.0", :require => false
  gem 'simplecov-json', :require => false
  gem 'simplecov-rcov', :require => false
  gem 'simplecov-console'
end
