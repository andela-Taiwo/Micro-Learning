require 'erb'
require 'sinatra/flash'
require 'pony'
require 'json'

module  Sinatra
  module App
    module SignUp

      def self.registered(app)

        app.get '/signup' do
          @title = 'SignUp Form'
          erb :'users/signup'
        end


        app.post "/unauthenticated" do
          session[:return_to] = env['warden.options'][:attempted_path] if session[:return_to].nil?
          puts env['warden.options'][:attempted_path]
          flash[:error] = env['warden.options'][:message] || 'Invalid email or password.'
          redirect 'login'
        end

        app.get '/login' do
          @title = 'Login Form'
          erb :'users/login'
        end
        app.post '/login' do
          if  env['warden'].authenticate(:admin)
            redirect '/admin', flash[:success] = 'Successfully logged in'
          elsif  env['warden'].authenticate!
            redirect '/topics', flash[:success] = 'Successfully logged in'
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
          @topics = Topic.order('updated_at  DESC, id  DESC ')
          @resources = Resource.order('updated_at  DESC, id  DESC ')
          @users = User.order('updated_at  DESC, id  DESC ')
          erb :'users/admin'
        end
        app.get '/admin/users' do
          check_admin_authentication
          @users = User.order(' created_at DESC, updated_at  ASC ')
          erb :'users/users'
        end

        app.get '/admin/user/:id/edit' do
          check_admin_authentication
          @user = User.find_by(id: params[:id])
          erb :'users/edit_user'
        end

        app.patch '/admin/user/:id/role' do
          check_admin_authentication
          @user = User.find_by_id( params[:id])
          if @user && params.has_key?('admin') && @user.update_column(:admin, params[:admin])
            flash[:success] = "Successfully updated #{@user.username} role"
            redirect 'admin/users'
          else
            flash[:error] = 'User does not exist.'
            redirect to '/admin/users'
          end
          erb :'users/users'
        end

        app.delete '/admin/user/:id/delete' do
          check_admin_authentication
          @user = User.find_by(id: params[:id])
          users = User.order('created_at DESC, updated_at  ASC')
          if @user
            users.delete(@user)
            flash[:success] = "Successfully deleted #{@user.username}"
            redirect to '/admin/users'
          else
            flash[:error] = 'User does not exist.'
            redirect to '/admin/users'
          end
          erb :'users/users'
        end

        app.post '/signup' do
          @user = User.new(params[:user])
          @errors = {}
          if @user.save
            warden_handler.set_user(@user)
            MailWorker.perform_at(1.minutes, current_user.email, current_user.username, nil) if current_user.email
            warden_handler.logout
            flash[:success] = 'Please confirm your email address to continue'
            redirect to '/login'
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
