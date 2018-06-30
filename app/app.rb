require 'sinatra'
require 'dotenv/load'
require 'sinatra/activerecord'
require 'erb'

set :database_file, 'config/database.yml'
ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'postgres://localhost/micro_learning')

Dir[File.join(File.dirname(__FILE__), 'controllers', '*.rb')].each { |lib| require_relative lib }

class App < Sinatra::Base
  register Sinatra::App::Home
end


# require_relative 'controllers/init'
require_relative 'models/init'
