require 'sinatra'
require 'dotenv/load'
require 'sinatra/activerecord'
require 'erb'
require 'warden'
require_relative 'helpers/auth_helper'
require 'sinatra/assetpack'
require 'sass'
require 'sidekiq'
require 'redis'
require 'sidekiq/scheduler'
require 'sidekiq/api'
require 'sidekiq/web'
require_relative 'workers/notification.rb'


Sidekiq::Scheduler.dynamic = true
if ENV['RACK_ENV'] == 'production' || ENV['RACK_ENV'] == 'development'
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'postgres://localhost/micro_learning')
else
  ActiveRecord::Base.establish_connection(:adapter => "sqlite3",
                                          :database => "db/#{ENV['SINATRA_ENV']}.sqlite")
end

Dir[File.join(File.dirname(__FILE__), 'controllers', '*.rb')].each { |lib| require_relative lib }
Dir[File.join(File.dirname(__FILE__), 'workers', '*.rb')].each { |file| load file }

Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end

class App < Sinatra::Base
  enable :static
  use Rack::Session::Cookie, :secret => ENV['SESSION_SECRET']
  register Sinatra::AssetPack
  register Sinatra::Flash
  helpers Sinatra::App::Helpers
  register Sinatra::App::Home
  register Sinatra::App::SignUp
  register Sinatra::App::TopicController
  register Sinatra::App::ResourceController
  register Sinatra::App::UserTopicController
  register Sinatra::App::TopicResourceController

  use Warden::Manager do |manager|
    manager.default_strategies :password
    manager.failure_app = App
    manager.serialize_into_session {|user| user.id}
    manager.serialize_from_session {|id| User.find(id) }
  end

  Warden::Manager.before_failure do |env,opts|
    env['REQUEST_METHOD'] = 'POST'
  end
  Warden::Strategies.add(:password) do
    def valid?
      params['email'] && params['password']
    end

  def authenticate!
    user = User.find_by_email(params['email'])
    if user && user.authenticate(params['password'])
      success! user
    else
      fail "Invalid email or password"
    end
  end

end

  Warden::Strategies.add(:admin) do
    def valid?
      params['email'] || params['password']
    end

    def authenticate!
      user = User.find_by_email(params['email'])
      if user && user.admin
        success! user
      else
        fail "Invalid email or password"
      end
    end
  end

  get '/' do
    html :index
  end

  def html(view)
    File.read(File.join('public', "#{view.to_s}.html"))
  end

  get '/test' do
    check_admin_authentication
    stats = Sidekiq::Stats.new
    workers = Sidekiq::Workers.new
    "
		<p>Processed: #{stats.processed}</p>
		<p>In Progress: #{workers.size}</p>
		<p>Enqueued: #{stats.enqueued}</p>
		<p><a href='/test'>Refresh</a></p>
		<p><a href='/test/add_job'>Add Job</a></p>
		<p><a href='/sidekiq'>Dashboard</a></p>
		"
  end

  get '/test/add_job' do
    check_admin_authentication
    "
		<p>Added Job: #{ResourceNotification.set(:queue => :default).perform_async}</p>
		<p><a href='/'>Back</a></p>
		"
  end

end

require_relative 'models/init'
