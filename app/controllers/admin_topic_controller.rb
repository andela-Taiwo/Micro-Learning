require "erb"
require "sinatra/flash"
require "pony"

module Sinatra
  module App
    module TopicController
      def self.registered(app)
        app.before do
          check_admin_authentication if request.path_info == "/admin/"
        end

        app.post "/admin/topic" do
          @topic = Topic.new(params[:topic])
          if @topic.save
            flash[:success] = "Successfully add a new topic"
          else
            error = @topic.errors.messages
            flash[:error] = error
          end
          redirect "/admin/topic"
        end

        app.get "/admin/topic" do
          @topics = Topic.order("updated_at  DESC, id  DESC ")
          @title = "Topic"
          erb :'topics/topic_form'
        end

        app.get "/admin/topic/:id" do
          @topic = Topic.find_by_id(params[:id])
          erb :'topics/edit_topic_form' if @topic
        end
        # app.before do
        #   @topic = Topic.find_by_id(params[:id])
        # end
        app.patch "/admin/topic/:id" do
          @topic = Topic.find_by_id(params[:id])
          if @topic
            data = clean_data(params)
            @topic.update_attributes(data)
            if @topic.save
              flash[:success] = "Successfully updated the topic"
            else
              flash[:error] = @topic.errors.messages
            end
            redirect "/admin/topic"
          end
        end

        app.delete "/admin/topic/:id" do
          @topic = Topic.find_by_id(params[:id])
          if @topic
            @topic.destroy
            flash[:success] = "Successfully deleted the topic"
          else
            flash[:halt] = "Unable to delete the topic"
          end
          redirect "/admin/topic"
        end
      end
    end
  end
end
