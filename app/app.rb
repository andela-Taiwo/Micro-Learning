require 'sinatra'
require 'dotenv/load'
require 'sinatra/activerecord'
require 'erb'
require_relative 'helpers/mailer'
require 'warden'
require_relative 'helpers/auth_helper'
# require_relative 'helpers/email_notification'
require 'sinatra/assetpack'
require 'sass'
require 'sidekiq'
require 'redis'
require 'sidekiq/scheduler'
require 'sidekiq/api'
require 'sidekiq/web'
require_relative 'workers/notification.rb'


Sidekiq::Scheduler.dynamic = true
set :database_file, 'config/database.yml'
ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'postgres://localhost/micro_learning')

Dir[File.join(File.dirname(__FILE__), 'controllers', '*.rb')].each { |lib| require_relative lib }
Dir[File.join(File.dirname(__FILE__), 'workers', '*.rb')].each { |file| load file }


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
  helpers Sinatra::App::Mailer


  Sidekiq.configure_server do |config|
    config.on(:startup) do
      Sidekiq.schedule = YAML.load_file(File.expand_path('../config/sidekiq.yml', __FILE__))
      # SidekiqScheduler::Scheduler.instance.reload_schedule!
      Sidekiq::Scheduler.reload_schedule!
      # Sidekiq::Scheduler.load_schedule!
    end
  end


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
    "
		<p>Added Job: #{ResourceNotification.perform_at(2.minutes)}</p>
		<p><a href='/'>Back</a></p>
		"
  end

end

require_relative 'models/init'
