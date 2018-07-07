require 'erb'
require 'sinatra/flash'
require 'pony'
require 'json'

module Sinatra
  module App
    module TopicController

      def self.registered(app)

        app.get '/topics' do
          check_authentication
          @topics = Topic.all
          erb  :topics
        end

        app.post '/admin/topic' do
          check_admin_authentication
          @topic = Topic.new(params[:topic])
          if @topic.save
            flash[:success] = 'Successfully add a new topic'
            redirect '/admin/topic'
          else
            @errors = @topic.errors.to_json
            error = JSON.parse(@errors)
            flash[:error] = error
            redirect '/admin/topic'
            end
        end

        app.get '/admin/topic' do
          check_admin_authentication
            @topics = Topic.all
            @title = 'Topic'
            erb :topic_form
        end

        app.get '/admin/topic/:id' do
        check_admin_authentication
        @topic = Topic.find_by_id(params[:id])
        if @topic
          erb :edit_topic_form
        end
        end
        app.patch '/admin/topic/:id/edit' do
          check_admin_authentication
          @topic = Topic.find_by_id(params[:id])
          if @topic
            erb :edit_topic_form
            @topic.title = params[:title] if params.has_key?('title')
            @topic.description = params[:description] if params.has_key?('description')
            if @topic.save
              flash[:success] = 'Successfully updated the topic'
              redirect '/admin/topic'
            else
              flash[:error] = 'Unable to update the topic'
            end
          end

        end

        app.delete '/admin/topic/:id/delete' do
          check_admin_authentication
          @topic = Topic.find_by_id(params[:id])
          if @topic.destroy
              flash[:success] = 'Successfully deleted the topic'
              redirect '/admin/topic'
          else
              flash[:halt] = 'Unable to delete the topic'
          end

        end

      end
    end
  end
end
