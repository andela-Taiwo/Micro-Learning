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
          @topics = Topic.order('updated_at  DESC, id  DESC ')
          erb  :'topics/topics'
        end

        app.get '/topic/:id' do
          check_authentication
          @topic = Topic.find_by(id: params[:id])
          if @topic
            erb  :'topics/topic_detail'
          else
            flash[:error] = "Topic not found"
            redirect '/topics'
          end

        end

        app.get '/user/topics/:id/resource' do
          check_authentication
          @topic = Topic.find_by(id: params[:id])
          @resources = @topic.resources unless @topic.nil?
          @resource =  @resources.sample(1) unless @resources.nil?
          @resource = @resource[0] unless @resource.nil?
          erb  :'resources/resource'
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
            @topics = Topic.order('updated_at  DESC, id  DESC ')
            @title = 'Topic'
            erb :'topics/topic_form'
        end

        app.get '/admin/topic/:id' do
        check_admin_authentication
        @topic = Topic.find_by_id(params[:id])
        if @topic
          erb :'topics/edit_topic_form'
        end
        end
        app.patch '/admin/topic/:id/edit' do
          check_admin_authentication
          @topic = Topic.find_by_id(params[:id])
          if @topic
            erb :'topics/edit_topic_form'
            @topic.title = params[:title].strip if params.has_key?('title') &&  params[:title].strip.length  > 0
            @topic.description = params[:description].strip if params.has_key?('description')
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
          if @topic
            @topic.destroy
            flash[:success] = 'Successfully deleted the topic'
            redirect '/admin/topic'
          else
            flash[:halt] = 'Unable to delete the topic'
            redirect '/admin/topic'
          end

        end

      end
    end
  end
end
