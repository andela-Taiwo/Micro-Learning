require "erb"
require "sinatra/flash"
require "pony"
require "json"

module  Sinatra
  module App
    module SignUp
      # @param [Object] app
      def self.registered(app)
        app.before do
          pass unless request.path_info == "/signup"
        end
        app.get "/signup" do
          @title = "SignUp Form"
          erb :'users/signup'
        end

        app.post "/signup" do
          @user = User.new(params[:user])
          @errors = {}
          if @user.save
            warden_handler.set_user(@user)
            MailWorker.perform_at(1.minutes, current_user.email, current_user.username, nil) if current_user.email
            warden_handler.logout
            flash[:success] = "Please confirm your email address to continue"
            redirect to "/login"
          else
            @errors = @user.errors.to_json
            error = JSON.parse(@errors)
            flash[:error] = error
            redirect "/signup"
          end
        end
      end
    end
  end
end
