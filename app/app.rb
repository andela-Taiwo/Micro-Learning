require 'sinatra'
require 'sinatra/activerecord'

set :database_file, 'config/database.yml'

class App < Sinatra::Base
  get '/' do
    'Welcome to Life Long Learner!'
  end
end