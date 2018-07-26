module Sinatra
  module App
    module LoginSession
      def self.registered(app)
        app.before do
          pass unless request.path_info == "/" ||
              request.path_info == "/login" ||
              request.path_info == "/signup"
        end

        app.get "/login" do
          @title = "Login Form"
          erb :'users/login'
        end

        app.post "/login" do
          if warden_handler.authenticate(:admin)
            redirect "/admin", flash[:success] = "Successfully logged in"
          elsif warden_handler.authenticate!
            redirect "/topics", flash[:success] = "Successfully logged in"
          else
            redirect "/login", flash[:error] = "Incorrect email or password"
          end
        end

        app.get "/logout" do
          warden_handler.raw_session.inspect
          warden_handler.logout
          flash[:success] = "Successfully logged out"
          redirect "/"
        end

        app.post "/unauthenticated" do
          if session[:return_to].nil?
            session[:return_to] = env["warden.options"][
                :attempted_path]
          end
          puts env["warden.options"][:attempted_path]
          flash[:error] = env["warden.options"][:message] ||
              "Invalid email or password."
          redirect "login"
        end
      end
    end
  end
end
