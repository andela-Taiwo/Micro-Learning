module Sinatra
  module App
    module Helpers
      private

      def warden_handler
        request.env["warden"]
      end

      def check_authentication
        redirect "/login" unless warden_handler.authenticated?
      end

      def check_admin_authentication
        check_authentication
        redirect "/login" unless current_user.admin
      end

      def current_user
        @current_user = warden_handler.user
        @current_user ||= User.find_by_id(session[:user_id])
      end

      def logged_in?
        !current_user.nil?
      end

      def admin_logged_in?
        logged_in? && current_user.admin
      end
    end
  end
end
