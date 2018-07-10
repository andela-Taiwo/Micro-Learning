require './app/app.rb'
require './app/controllers/user.rb'
# require 'sidekiq/web'
# require 'sidekiq/web'
require 'sidekiq-scheduler/web'

use Rack::MethodOverride


run App

run Rack::URLMap.new('/' => App, '/sidekiq' => Sidekiq::Web)
