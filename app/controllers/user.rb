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
          flash[:error] = env['warden'].message  || 'You must to login to continue'
          redirect '/login'
        end

        app.get '/signup' do
          @title = 'SignUp Form'
          erb :signup
        end


        app.post "/unauthenticated" do
          session[:return_to] = env['warden.options'][:attempted_path] if session[:return_to].nil?

          # Set the error and use a fallback if the message is not defined
          flash[:error] = env['warden.options'][:message] || "You must log in"
          redirect 'login'
        end

        app.get '/login' do
          @title = 'Login Form'
          erb :login
        end
        app.post '/login' do
          user =  warden_handler.authenticate!
          if user
            redirect '/dashboard', flash[:success] = 'Successfully logged in'
          else
            flash.now.alert = env['warden'].message
            redirect '/login'
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
