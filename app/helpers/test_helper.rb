require 'active_support'
module Sinatra
  module App
    module Test

      extend ActiveSupport::Concern
      included  do
        include Rack::Test::Methods
        let(:current_user) { nil }

        def app
          lambda {|env|
            env['warden'] = warden
            Sinatra::App.call(env)
          }
        end

        def warden
          FakeWarden.new current_user
        end
      end

      class FakeWarden
        attr_accessor :user

        def initialize(user)
          @user = user
        end

        def authenticated?
          !!user
        end
      end

    end
  end
end