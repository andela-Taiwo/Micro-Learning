require "erb"
require "sinatra/flash"
require "pony"
require "json"

module Sinatra
  module App
    module AdminResourceController
      # @param [Object] app
      def self.registered(app)
        app.before "/admin/*" do
          check_admin_authentication
        end

        app.get "/resources" do
          @resources = Resource.order("created_at DESC")
          erb :'resources/resources'
        end

        app.post "/admin/resource" do
          @resource = Resource.new(params[:resource])
          if @resource.save
            flash[:success] = "Successfully add a new resource"
          else
            error = @resource.errors.messages
            flash[:warning] = error
          end
          redirect "/admin/resource"
        end

        app.get "/admin/resource" do
          @resources = Resource.order("updated_at DESC")
          @title = "Resources"
          erb :'resources/resource_form'
        end

        app.get "/admin/resource/:id" do
          @resource = Resource.find_by(id: params[:id])
          erb :'resources/edit_resource_form' if @resource
        end

        app.patch "/admin/resource/:id" do
          @resource = Resource.find_by(id: params[:id])
          if @resource
            erb :'resources/edit_resource_form'
            data = clean_data(params)
            @resource.update(data)
            if @resource.save
              flash[:success] = "Successfully updated the resource"
            else
              error = @resource.errors.messages
              flash[:warning] = error
            end
            redirect "/admin/resource"
          end
        end

        app.delete "/admin/resource/:id" do
          @resource = Resource.find_by(id: params[:id])
          if @resource
            @resource.destroy
            flash[:success] = "Successfully deleted the resource"
          else
            flash[:warning] = "Unable to delete the resource"
          end
          redirect "/admin/resource"
        end
      end
    end
  end
end
