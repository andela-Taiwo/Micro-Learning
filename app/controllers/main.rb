require 'erb'

module  Sinatra
  module App
    module Home
      def self.registered(app)
        app.get '/' do
          @title = 'Life Long'
          @message = 'Welcome to 3L'
          erb :index
        end
        app.get '/about' do
          @title = 'About 3L'
          @message = 'Welcome to 3L'
          erb :about
        end
      end
    end
  end
end
