require './app/app.rb'
require './app/controllers/user.rb'

use Rack::MethodOverride
run App
