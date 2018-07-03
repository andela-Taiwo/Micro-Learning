
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

      def current_user
        warden_handler.user
      end

    end
  end
  end