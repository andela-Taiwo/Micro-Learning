require 'erb'
require 'sinatra/flash'
require 'pony'
require 'json'

module Sinatra
  module App
    module UserTopicController

      def self.registered(app)

        app.get '/dashboard' do
          check_authentication
          user_id = current_user.id
          @user= User.find(user_id)
          @user_topics = @user.topics.order('created_at DESC')
          erb  :'users/dashboard'
        end

        app.post '/user/topics/:id' do
          check_authentication
          @topic = Topic.find(params[:id])
          @user = current_user
          existing_topic = @user.topics.find_by(id: params[:id])
          unless existing_topic.nil?
            flash[:warning] = 'You have already added the topic.'
            redirect '/topics'
          end
          @user_topics = @user.topics << @topic if @topic && @user
          if @user_topics.nil?
            @errors = @user_topics.errors.to_json
            error = JSON.parse(@errors)
            flash[:error] = error
            redirect '/topic'
          else
            @resources = @topic.resources
            @resources = @resources.sample(1)
            if current_user.email
              message = 'Successfully add a new topic to your learning path'
              MailWorker.perform_at(1.minutes, current_user.email,
                                    current_user.username, @topic.title)
              flash[:success] = message
              redirect '/dashboard'
            end
          end
        end
        app.delete '/user/topic/:id/delete' do
          check_authentication
          @user = current_user
          @user_topics = current_user.topics
          @topic = @user_topics.find(params[:id])
          if @user_topics.delete(@topic)
            flash[:success] = 'Successfully deleted the topic'
            redirect '/dashboard'
          else
            flash[:halt] = 'Unable to delete the topic'
            redirect '/dashboard'
          end

        end

      end
    end
  end
end
