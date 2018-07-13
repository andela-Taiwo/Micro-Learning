require 'erb'
require 'sinatra/flash'
require 'pony'
require 'json'

module Sinatra
  module App
    module TopicResourceController

      def self.registered(app)
        app.get '/admin/topic/:id/resources' do
          check_authentication
          @resources = Resource.all
          @topic = Topic.find_by(id: params[:id])
          @topic_resources = @topic.resources
          @title = 'Topic Resources'
          erb :topic_resources
        end

        app.delete '/admin/topic/:id/resource/:resource_id/delete' do
          check_admin_authentication
          @topic = Topic.find(params[:id])
          id = params[:id]
          @topic_resources = @topic.resources
          @resource = @topic.resources.find(params[:resource_id])
          if @topic_resources.delete(@resource)
            flash[:success] = 'Successfully remove the resource.'
            redirect '/admin/topic/' + id + '/resources'
          else
            flash[:halt] = 'Unable to delete the topic'
            redirect '/admin/topic/' + id + '/resources'
          end
        end

        app.get '/admin/topic/:id/resource/:resource_id' do
          check_admin_authentication
          @topic = Topic.find(params[:id])
          id = params[:id]
          @topic_resources = @topic.resources
          @resource = @topic.resources.find(params[:resource_id])
          if @resource
            erb :resource
          else
            flash[:halt] = 'Resource could not be found.'
            redirect '/admin/topic/' + id + '/resources'
          end
        end

        app.post '/admin/topic/:id/resources' do
          check_admin_authentication
          id = params[:id]
          puts params
          resource_id = params[:topic][:resource_ids]  if params.has_key?('topic')
          resources = Resource.find_by(id: resource_id)
          @topic = Topic.find_by(id: params[:id])
          existing_resources = @topic.resources.find_by(id: resource_id)

          if existing_resources
            flash[:error] = 'The resource already exist for the topic.'
            redirect '/admin/topic/' + id + '/resources'
          elsif @topic && resources
            @topic.resources <<  resources
            flash[:success] = 'Resource successfully added to the topic.'
            redirect '/admin/topic/' + id + '/resources'
          else
            flash[:error] = 'Resource or the topic is not available'
            redirect '/admin/topic/' + id + '/resources'
          end
        end

      end
    end
  end
end
