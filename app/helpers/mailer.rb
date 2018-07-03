module Sinatra
  module App
    module Mailer
      def send_mail recipient

        Pony.options = {
            :subject => "Confirm email",
            :via => :smtp,
            :html_body => (erb :registration_confirmation, :layout => false),
            :via_options => {
                :address              => 'smtp.gmail.com',
                :port                 => '587',
                :enable_starttls_auto => true,
                :user_name            => ENV['EMAIL'],
                :password             => ENV['EMAIL_PASS'],
                :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
                :domain               => "localhost.localdomain"
            }
        }
        Pony.mail(:to => recipient)
      end
    end
  end
end

