require 'erb'
require 'jwt'
require 'sinatra/flash'
require 'pony'
require 'pry'
require 'json'

module  Sinatra
  module App
    module SignUp
      def self.registered(app)
        app.get '/signup' do
          @title = 'SignUp Form'
          erb :signup

        end
        app.post '/signup' do
          @user = User.new(params[:user])
          @errors = {}
          if @user.save
            send_mail(@user['email'])
            flash[:success] = 'Please confirm your email address to continue'
            erb :signup
          else
            @errors =  @user.errors.to_json
            error = JSON.parse(@errors)
            puts @errors
            # flash[:error] = 'Ooooppss, something went wrong!'
            flash[:error] = error
            redirect '/signup'
          end
        end
      end
    end
  end
end
