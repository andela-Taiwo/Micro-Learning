module Sinatra
  module App
    module DataHelper
      private

      def clean_data(params)
        title = params[:title].strip if params.key?("title")
        description = params[:description].strip if params.key?("description")
        url = params[:url].strip if params.key?("url")

        if url.nil?
          { title: title, description: description }
        else
          {
            title: title,
            description: description,
            url: url,
          }
        end
      end
    end
  end
end
