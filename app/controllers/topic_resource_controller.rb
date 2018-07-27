require "erb"
require "sinatra/flash"
require "pony"
require "json"

module Sinatra
  module App
    module TopicResourceController
      def self.registered(app)
        app.before "/admin/*" do
          check_admin_authentication
        end

        app.get "/admin/topic/:id/resources" do
          @resources = Resource.all
          @topic = Topic.find_by(id: params[:id])

          @title = "Topic Resources"
          if @topic
            @topic_resources = @topic.resources unless @topic.nil? || @topic.resources.empty?
            erb :'resources/topic_resources'
          else
            flash[:warning
            ] = "Topic does not exist"
            redirect "/admin/topic"
          end
        end

        app.delete "/admin/topic/:id/resource/:resource_id" do
          @topic = Topic.find(params[:id])
          id = params[:id]
          @topic_resources = @topic.resources unless @topic.nil?
          @resource = @topic.resources.find_by(id: params[:resource_id]) unless @topic.resources.nil?
          if @topic_resources && @resource
            @topic_resources.destroy(@resource)
            flash[:success] = "Successfully remove the resource."
          else
            flash[:warning] = "Unable to delete the resource"
          end
          redirect "/admin/topic/#{id}/resources"
        end

        app.get "/admin/topic/:id/resource/:resource_id" do
          @topic = Topic.find(params[:id])
          id = params[:id]
          @topic_resources = @topic.resources unless @topic.nil?
          @resource = @topic.resources.find(params[:resource_id])
          if @resource
            erb :'resources/resource'
          else
            flash[:warning] = "Resource could not be found."
            redirect "/admin/topic/" + id + "/resources"
          end
        end

        app.post "/admin/topic/:id/resources" do
          id = params[:id]
          resource_ids = params[:topic][:resource_ids] if params.key?("topic")
          resources = Resource.find(resource_ids) unless resource_ids.nil?
          @topic = Topic.find_by(id: params[:id])
          existing_resources = @topic.resources.find_by(id: resource_ids)

          if existing_resources
            flash[:warning] = "The resource #{existing_resources.title} already exist for the topic."
          elsif @topic && resources
            @topic.resources << resources
            flash[:success] = "Resource successfully added to the topic."
          else
            flash[:warning] = "Resource or the topic is not available"
          end
          redirect "/admin/topic/" + id + "/resources"
        end
      end
    end
  end
end
