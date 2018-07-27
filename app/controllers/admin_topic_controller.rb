require "erb"
require "sinatra/flash"
require "pony"

module Sinatra
  module App
    module TopicController
      def self.registered(app)
        app.before "/admin/*" do
          check_admin_authentication
        end

        app.post "/admin/topic" do
          @topic = Topic.new(params[:topic])
          if @topic.save
            flash[:success] = "Successfully add a new topic"
          else
            error = @topic.errors.messages
            flash[:warning] = error
          end
          redirect "/admin/topic"
        end

        app.get "/admin/topic" do
          @topics = Topic.order("updated_at  DESC, id  DESC ")
          @title = "Topic"
          erb :'topics/topic_form'
        end

        app.get "/admin/topic/:id" do
          @topic = Topic.find_by(id: params[:id])
          erb :'topics/edit_topic_form' if @topic
        end

        app.patch "/admin/topic/:id" do
          @topic = Topic.find_by(id: params[:id])
          if @topic
            data = clean_data(params)
            @topic.update(data)
            if @topic.save
              flash[:success] = "Successfully updated the topic"
            else
              flash[:warning] = @topic.errors.messages
            end
            redirect "/admin/topic"
          end
        end

        app.delete "/admin/topic/:id" do
          @topic = Topic.find_by(id: params[:id])
          if @topic
            @topic.destroy
            flash[:success] = "Successfully deleted the topic"
          else
            flash[:warning] = "Unable to delete the topic"
          end
          redirect "/admin/topic"
        end
      end
    end
  end
end
