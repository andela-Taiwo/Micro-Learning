require 'erb'
require 'sinatra/flash'
require 'pony'
require 'json'

module Sinatra
  module App
    module ResourceController

      def self.registered(app)

        app.get '/resources' do
          check_authentication
          @resources = Resource.order('created_at DESC')
          erb  :resources
        end

        app.post '/admin/resource' do
          check_admin_authentication
          @resource = Resource.new(params[:resource])
          if @resource.save
            flash[:success] = 'Successfully add a new resource'
            redirect '/admin/resource'
          else
            @errors = @resource.errors.to_json
            error = JSON.parse(@errors)
            flash[:error] = error
            redirect '/admin/resource'
            end
        end

        app.get '/admin/resource' do
          check_admin_authentication
            @resources = Resource.order('updated_at DESC')
            @title = 'Resources'
            erb :resource_form
        end

        app.get '/admin/resource/:id' do
        check_admin_authentication
        @resource = Resource.find_by_id(params[:id])
        if @resource
          erb :edit_resource_form
        end
        end
        app.patch '/admin/resource/:id/edit' do
          check_admin_authentication
          @resource = Resource.find_by_id(params[:id])
          if @resource
            erb :edit_resource_form

            @resource.title = params[:title] if params.has_key?('title')
            @resource.description = params[:description] if params.has_key?('description')
            @resource.url = params[:url] if params.has_key?('url')

            if @resource.save
              flash[:success] = 'Successfully updated the resource'
              redirect '/admin/resource'
            else
              flash[:error] = 'Unable to update the resource'
            end
          end

        end

        app.delete '/admin/resource/:id/delete' do
          check_admin_authentication
          @resource = Resource.find_by_id(params[:id])
          if @resource.destroy
              flash[:success] = 'Successfully deleted the resource'
              redirect '/admin/resource'
          else
              flash[:halt] = 'Unable to delete the resource'
          end

        end

      end
    end
  end
end