require './app/app.rb'
require './app/controllers/user.rb'
require 'sidekiq/web'
require 'sidekiq-scheduler/web'

use Rack::MethodOverride

run App

Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == [ENV['ADMIN'], ENV['ADMIN_PASS']]
end

run Rack::URLMap.new('/' => App, '/sidekiq' => Sidekiq::Web)
