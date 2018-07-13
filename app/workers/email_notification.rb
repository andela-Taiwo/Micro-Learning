require 'sidekiq'
require 'erb'
require 'tilt/erb'


class  MailWorker
  include Sidekiq::Worker
  def perform(msg = "send resource", recipient, user, topic)
    $redis.lpush(msg, activate_email(recipient, user, topic))
  end

  def activate_email(recipient, user, topic)
    send_mail(recipient, user, topic)
  end
  def send_mail (recipient, user, topic)
    if  topic.nil?
      path = File.expand_path('../views/registration_confirmation.erb', File.dirname(__FILE__))
      file = ERB.new(File.read(path)).result(binding)
    else
      path = File.expand_path('../views/enrollment_message.erb', File.dirname(__FILE__))
      file = ERB.new(File.read(path)).result(binding)
    end

    Pony.options = {
        :subject => "Resource Notification",
        :via => :smtp,
        :headers => { 'Content-Type' => 'text/html' },
        :body => file,
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