require 'sinatra'
require 'dotenv/load'
require 'sinatra/activerecord'
require 'erb'
require_relative 'helpers/mailer'
require 'warden'
require_relative 'helpers/auth_helper'



set :database_file, 'config/database.yml'
ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'postgres://localhost/micro_learning')

Dir[File.join(File.dirname(__FILE__), 'controllers', '*.rb')].each { |lib| require_relative lib }

class App < Sinatra::Base
  enable :sessions
  use Rack::Session::Cookie, secret: ENV['SESSION_SECRET']
  register Sinatra::Flash
  helpers Sinatra::App::Helpers
  register Sinatra::App::Home
  register Sinatra::App::SignUp
  helpers Sinatra::App::Mailer


  use Warden::Manager do |manager|
    manager.default_strategies :password
    manager.failure_app = self
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


end

# require_relative 'controllers/init'
# require_relative 'helpers/mailer'
require_relative 'models/init'
