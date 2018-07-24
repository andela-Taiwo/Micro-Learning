module Sinatra
  module App
    module DataHelper
      private

      def clean_data(title=nil, url=nil, description=nil, params)
        title = params[:title].strip if params.has_key?("title")
        description= params[:description].strip if params.has_key?("description")
        url = params[:url].strip if params.has_key?("url")

        parameters = url.nil? ?
                         {
                             title: title,
                             description: description,
                         } :
                         {
                             title: title,
                             description: description,
                             url: url
                         }
      end
    end
  end
end
