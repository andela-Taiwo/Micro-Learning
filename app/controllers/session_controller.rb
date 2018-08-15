module Sinatra
  module App
    module LoginSession
      def self.registered(app)
        app.before do
          url =  request.path_info
          status = url == "/" || url == "/login" || url == "/signup"
          pass unless  status
        end

        app.get "/login" do
          redirect '/topics' unless current_user.nil?
          @title = "Login Form"
          erb :'users/login'
        end

        app.post "/login" do
          if warden_handler.authenticate(:admin)
            redirect "/admin", flash[:success] = "Successfully logged in"
          elsif warden_handler.authenticate!
            redirect "/topics", flash[:success] = "Successfully logged in"
          else
            redirect "/login", flash[:warning] = "Incorrect Email or Password"
          end
        end

        app.get "/logout" do
          warden_handler.raw_session.inspect
          warden_handler.logout
          flash[:success] = "Successfully logged out"
          redirect "/"
        end
      end
    end
  end
end
