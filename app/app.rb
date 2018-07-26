require "sinatra"
require "dotenv/load"
require "sinatra/activerecord"
require "erb"
require "warden"
require_relative "helpers/auth_helper"
require_relative "helpers/data_helper"
require "sinatra/assetpack"
require "sass"
require "sidekiq"
require "redis"
require "sidekiq/scheduler"
require "sidekiq/api"
require "sidekiq/web"
require_relative "workers/notification.rb"

Sidekiq::Scheduler.dynamic = true

Dir[File.join(File.dirname(__FILE__),
              "controllers", "*.rb")].each { |lib| require_relative lib }
Dir[File.join(File.dirname(__FILE__),
              "workers", "*.rb")].each { |file| load file }

Sidekiq.configure_client do |config|
  config.redis = { size: 1 }
end

class App < Sinatra::Base
  enable :static
  postgres_db = "postgres://localhost/micro_learning"
  sqlite_db = "db/#{ENV['SINATRA_ENV']}.sqlite"
  database_connection = ENV["DATABASE_URL"] || postgres_db
  if ENV["RACK_ENV"] == "production" || ENV["RACK_ENV"] == "development"
    ActiveRecord::Base.establish_connection(database_connection)
  else
    ActiveRecord::Base.establish_connection(adapter:  "sqlite3",
                                            database: sqlite_db)
  end

  use Rack::Session::Cookie, secret: ENV["SESSION_SECRET"]
  register Sinatra::AssetPack
  register Sinatra::Flash
  helpers Sinatra::App::Helpers
  helpers Sinatra::App::DataHelper
  register Sinatra::App::Home
  register Sinatra::App::LoginSession
  register Sinatra::App::SignUp
  register Sinatra::App::TopicController
  register Sinatra::App::AdminResourceController
  register Sinatra::App::UserResourceController
  register Sinatra::App::UserTopicController
  register Sinatra::App::TopicResourceController
  register Sinatra::App::DashboardController

  use Warden::Manager do |manager|
    manager.default_strategies :password
    manager.failure_app = App
    manager.serialize_into_session(&:id)
    manager.serialize_from_session { |id| User.find(id) }
  end

  Warden::Manager.before_failure do |env, _opts|
    env["REQUEST_METHOD"] = "POST"
  end
  Warden::Strategies.add(:password) do
    def valid?
      params["email"] && params["password"]
    end

    def authenticate!
      user = User.find_by(email: params["email"])
      if user && user.authenticate(params["password"])
        success! user
      else
        fail "Invalid email or password"
      end
    end
  end

  Warden::Strategies.add(:admin) do
    def valid?
      params["email"] || params["password"]
    end

    def authenticate!
      user = User.find_by(email: params["email"])
      if user && user.admin
        success! user
      else
        fail "Invalid email or password"
      end
    end
  end

  get "/" do
    html :index
  end

  def html(view)
    File.read(File.join("public", "#{view}.html"))
  end

  before { check_admin_authentication if request.path_info == "/test/" }

  get "/test" do
    @stats = Sidekiq::Stats.new
    @workers = Sidekiq::Workers.new
    erb :"users/sidekiq"
  end

  get "/test/add_job" do
    "
		<p>Added Job: #{ResourceNotification.set(queue: :default).perform_async}</p>
		<p><a href='/'>Back</a></p>
		"
  end
end

require_relative "models/init"
