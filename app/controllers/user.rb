require 'erb'

module  Sinatra
  module App
    module SignUp
      def self.registered(app)
        app.get '/signup' do
          erb :signup
        end
      end
    end
  end
end
