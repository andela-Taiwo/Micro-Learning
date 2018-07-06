
module Sinatra
  module App
    module Helpers

      private

      def warden_handler
        env['warden']
      end

      def check_authentication
        unless warden_handler.authenticated?
          redirect '/login'
        end

      end

      def check_admin_authentication
        check_authentication
        unless current_user.admin
          redirect '/login'
        end
      end

      def current_user
        @current_user = warden_handler.user
        @current_user ||= User.find_by_id(session[:user_id])
      end

      def logged_in?
        !current_user.nil?
      end

      def admin_logged_in?
        true if logged_in? && current_user.admin == true
      end

    end
  end
end
