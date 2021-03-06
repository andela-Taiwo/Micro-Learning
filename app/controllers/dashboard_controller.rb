module Sinatra
  module App
    module DashboardController
      def self.registered(app)
        app.before "/admin/*" do
          check_admin_authentication
        end

        app.get "/admin" do
          @topics = Topic.count
          @resources = Resource.count
          @users = User.count
          erb :'users/admin'
        end

        app.get "/admin/users" do
          @users = User.order(" created_at DESC, updated_at  ASC ")
          erb :'users/users'
        end

        app.get "/admin/user/:id" do
          @user = User.find_by(id: params[:id])
          erb :'users/edit_user'
        end

        app.patch "/admin/user/:id" do
          @user = User.find_by(id: params[:id])
          if @user && params.key?("admin") && @user.update_column(:admin, params[:admin])
            flash[:success] = "Successfully updated #{@user.username} role"
            redirect "admin/users"
          else
            flash[:warning] = "User does not exist."
            redirect to "/admin/users"
          end
          erb :'users/users'
        end

        app.delete "/admin/user/:id" do
          @user = User.find_by(id: params[:id])
          users = User.order("created_at DESC, updated_at  ASC")
          if @user
            users.delete(@user)
            flash[:success] = "Successfully deleted #{@user.username}"
          else
            flash[:warning] = "User does not exist."
          end
          redirect to "/admin/users"
          erb :'users/users'
        end
      end
    end
  end
end
