require 'sidekiq'
require 'sidekiq-scheduler'

Sidekiq.configure_server do |config|
  config.on(:startup) do
    config.redis = { :size => 27 }
    Sidekiq.schedule = YAML.load_file(File.expand_path('../../config/sidekiq.yml', __FILE__))
    SidekiqScheduler::Scheduler.instance.reload_schedule!
  end
end

class ResourceNotification
  include Sidekiq::Worker
  uri = URI.parse(ENV["REDISCLOUD_URL"] || "redis://localhost:6379/")
  $redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
  def perform (msg = "send resource")
    users = User.all
    puts 'Load all users'
    users.each do |user|
      topics = user.topics
      topic = topics.sample(1)
      if topic[0]
        resources = topic[0].resources
        resource = resources.sample(1)
        $redis.lpush(msg, activate_email(user.email, resource[0].url)) if resource[0]
      end
    end
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