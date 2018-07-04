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

        app.post '/auth/unauthenticated' do
          session[:return_to] = env['warden.options'][:attempted_path]
          puts env['warden.options'][:attempted_path]
          flash[:error] = env['warden'].message  || 'You must to login to continue.'
          redirect '/login'
        end

        app.get '/signup' do
          @title = 'SignUp Form'
          erb :signup
        end


        app.post "/unauthenticated" do
          session[:return_to] = env['warden.options'][:attempted_path] if session[:return_to].nil?
          flash[:error] = env['warden.options'][:message] || 'You must to login to continue'
          redirect 'login'
        end

        app.get '/login' do
          @title = 'Login Form'
          erb :login
        end
        app.post '/login' do
          user = warden_handler.authenticate!
          if user
            redirect '/dashboard', flash[:success] = 'Successfully logged in'
          else
            redirect '/login', flash.now.alert = env['warden'].message

          end
        end

        app.get '/logout' do
          warden_handler.raw_session.inspect
          warden_handler.logout
          flash[:success] = 'Successfully logged out'
          redirect '/'

        end

        app.get '/admin' do
          check_authentication
          erb :admin
        end

        app.get '/dashboard' do
          check_authentication
          erb :dashboard
        end

        app.post '/signup' do
          puts params[:user]
          @user = User.new(params[:user])
          @errors = {}
          if @user.save
            send_mail(@user['email'])
            flash[:success] = 'Please confirm your email address to continue'
            redirect '/login'
          else
            @errors = @user.errors.to_json
            error = JSON.parse(@errors)
            flash[:error] = error
            redirect '/signup'
          end
        end
      end
    end
  end
end
