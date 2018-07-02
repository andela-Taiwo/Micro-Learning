require 'erb'
require 'jwt'
require 'sinatra/flash'
require 'pony'

module  Sinatra
  module App
    module SignUp
      def self.registered(app)
        app.get '/signup' do
          @title = 'SignUp Form'
          erb :signup

        end
        app.post '/signup' do
          @username = params['username']
          @password = params['password_digest']
          @email = params['email']
          @password_confirm = params['password_confirmation']
          puts "#{@username} #{@password} #{@email} #{@password_confirm}"
          hmac_secret = ENV['SECRET']
          token = JWT.encode params, hmac_secret, 'HS256'
          @user = User.new(:username => @username, :password => @password,
                           :email => @email,
                           :password_confirmation => @password_confirm
          )
          if @user.save
            Pony.options = {
                :subject => "Confirm email",
                :via => :smtp,
                :html_body => (erb :registration_confirmation, @user),
                :via_options => {
                    :address              => 'smtp.gmail.com',
                    :port                 => '587',
                    :enable_starttls_auto => true,
                    :user_name            => ENV['EMAIL'],
                    :password             => ENV['EMAIL_PASS'] ,
                    :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
                    :domain               => "localhost.localdomain"
                }
            }
            Pony.mail(:to => @email)

            flash[:success] = 'Please confirm your email address to continue'
            erb :signup
          else
            flash[:error] = 'Ooooppss, something went wrong!'
            redirect '/signup'
          end
        end
      end
    end
  end
end
