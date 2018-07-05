require 'erb'
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


        app.post "/unauthenticated" do
          session[:return_to] = env['warden.options'][:attempted_path] if session[:return_to].nil?
          puts env['warden.options'][:attempted_path]
          flash[:error] = env['warden.options'][:message] || 'You must to login to continue'
          redirect 'login'
        end

        app.get '/login' do
          @title = 'Login Form'
          erb :login
        end
        app.post '/login' do
          if  env['warden'].authenticate(:admin)
            redirect '/admin', flash[:success] = 'Successfully logged in'
          elsif  env['warden'].authenticate!
            redirect '/dashboard', flash[:success] = 'Successfully logged in'
          else
            redirect '/login', flash[:error] = 'Incorrect email or password'
          end
        end

        app.get '/logout' do
          warden_handler.raw_session.inspect
          warden_handler.logout
          flash[:success] = 'Successfully logged out'
          redirect '/'

        end

        app.get '/admin' do
          check_admin_authentication
          @topics = Topic.all
          @resources = Resource.all
          @users = User.all
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
            warden_handler.set_user(@user)
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
