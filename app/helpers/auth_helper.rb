
module Sinatra
  module App
    module Helpers
      # private

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
        # throw(:warden, error: 'unauthenticated') unless env['warden'].authenticated?(:admin)
        # present :current_user, env['warden'].user
        unless current_user.admin
          redirect '/login'
        end
      end

      def current_user
        @current_user = warden_handler.user
        @current_user ||= User.find_by_id(session[:user_id])
      end

    end
  end
end
