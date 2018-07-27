require "erb"
require "sinatra/flash"

module Sinatra
  module App
    module UserTopicController
      def self.registered(app)
        app.before do
          url = request.path_info
          check_authentication unless (url == "/login" ||
              url == "/about") || (url == "/" || url == "/signup")
        end

        app.get "/dashboard" do
          @user = current_user
          @user_topics = @user.topics.order("created_at DESC")
          erb :'users/dashboard'
        end

        app.get "/topics" do
          @topics = Topic.order("updated_at  DESC, id  DESC ")
          erb :'topics/topics'
        end

        app.get "/topic/:id" do
          @topic = Topic.find_by(id: params[:id])
          @user_topics = current_user.topics
          @enrolled_status = @user_topics.find_by(id: params[:id]) if @user_topics
          if @enrolled_status.nil?
            @button = 'Enroll'
          else
            @button = 'Enrolled'
          end
          if @topic
            erb :'topics/topic_detail'
          else
            flash[:warning] = "Topic not found"
            redirect "/topics"
          end
        end

        app.post "/user/topics/:id" do
          @topic = Topic.find(params[:id])
          @user = current_user
          existing_topic = @user.topics.find_by(id: params[:id])

          unless existing_topic.nil?
            flash[:warning] = "You have already added the topic."
            redirect "/topic/#{@topic.id}"
          end

          @user_topics = @user.topics << @topic if @topic && @user
          if @user_topics.nil?
            error = @user_topics.errors.messages
            flash[:warning] = error
            redirect "/topic"
          else
            @resources = @topic.resources
            @resources = @resources.sample(1)
            if current_user.email
              message = "Successfully add a new topic to your learning path"
              MailWorker.perform_at(1.minute, current_user.email, current_user.username, @topic.title)
              flash[:success] = message
              redirect "/dashboard"
            end
          end
        end

        app.delete "/user/topic/:id" do
          @user = current_user
          @user_topics = current_user.topics
          @topic = @user_topics.find(params[:id])
          if @user_topics.delete(@topic)
            flash[:success] = "Successfully deleted the topic"
          else
            flash[:warning] = "Unable to delete the topic"
          end
          redirect "/dashboard"
        end
      end
    end
  end
end
