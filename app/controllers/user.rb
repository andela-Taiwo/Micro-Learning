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
          redirect "/" unless current_user.nil?
          @title = "SignUp Form"
          erb :"users/signup"
        end

        app.post "/signup" do
          @user = User.new(params[:user])
          if @user.save
            warden_handler.set_user(@user)
            if current_user.email
              MailWorker.perform_at(1.minute,
                                    current_user.email,
                                    current_user.username, nil)
            end
            warden_handler.logout
            flash[:success] = "Please confirm your email address to continue"
            redirect to "/login"
          else
            flash[:warning] = @user.errors.messages
            redirect "/signup"
          end
        end
      end
    end
  end
end
