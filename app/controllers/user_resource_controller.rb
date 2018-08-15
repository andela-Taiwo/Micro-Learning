require "erb"
require "sinatra/flash"
require "pony"
require "json"

module Sinatra
  module App
    module UserResourceController
      def self.registered(app)
        app.before do
          url = request.path_info
          status = (url == "/login" || url == "/about") || (url == "/" || url == "/signup")
          check_authentication unless status
        end

        app.get "/resources" do
          @resources = Resource.order("created_at DESC")
          erb :'resources/resources'
        end

        app.get "/user/topics/:id/resource" do
          @topic = Topic.find_by(id: params[:id])
          @resources = @topic.resources unless @topic.nil?
          @resource =  @resources.sample(1) unless @resources.nil?
          @resource = @resource[0] unless @resource.nil?
          erb :'resources/resource'
        end
      end
    end
  end
end
