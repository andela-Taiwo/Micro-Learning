module Sinatra
  module App
    module DataHelper
      private

      def clean_data(title = nil, url = nil, description = nil, params)
        title = params[:title].strip if params.key?("title")
        description = params[:description].strip if params.key?("description")
        url = params[:url].strip if params.key?("url")

        url.nil? ?
                         {
                           title:       title,
                           description: description,
                         } :
                         {
                           title:       title,
                           description: description,
                           url:         url,
                         }
      end
    end
  end
end
