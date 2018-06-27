require 'sinatra'
require 'dotenv/load'
require 'sinatra/activerecord'

set :database_file, 'config/database.yml'

ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || 'postgres://localhost/mydb')


class App < Sinatra::Base
  get '/' do
    'Welcome to Life Long Learner!'
  end
end