require 'sidekiq'
class  MailWorker
  include Sidekiq::Worker
  # $redis = Redis.new
  def perform(msg = "send resource", recipient, url)
    $redis.lpush(msg, activate_email(recipient, url))
  end

  def activate_email(recipient, url)
    send_mail(recipient, url)
  end
  def send_mail (recipient, url)

    Pony.options = {
        :subject => "Resource Notification",
        :via => :smtp,
        :body => (url),
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