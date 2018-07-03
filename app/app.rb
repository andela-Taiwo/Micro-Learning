require 'sinatra'
require 'dotenv/load'
require 'sinatra/activerecord'
require 'erb'
require_relative 'helpers/mailer'

enable :sessions
set :database_file, 'config/database.yml'
ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'postgres://localhost/micro_learning')

Dir[File.join(File.dirname(__FILE__), 'controllers', '*.rb')].each { |lib| require_relative lib }

class App < Sinatra::Base
  enable :sessions
  register Sinatra::Flash
  register Sinatra::App::Home
  register Sinatra::App::SignUp
  helpers Sinatra::App::Mailer
end


# require_relative 'controllers/init'
# require_relative 'helpers/mailer'
require_relative 'models/init'
