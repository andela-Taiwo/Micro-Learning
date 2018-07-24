require "sidekiq"
require "sidekiq-scheduler"
require_relative "../../app/helpers/ponymail"
Sidekiq.configure_server do |config|
  config.on(:startup) do
    config.redis = {size: 27}
    Sidekiq.schedule = YAML.load_file(File.expand_path("../config/sidekiq.yml", __dir__))
    SidekiqScheduler::Scheduler.instance.reload_schedule!
    Sidekiq::Extensions.enable_delay!
  end
end

class ResourceNotification
  include Sidekiq::Worker
  uri = URI.parse(ENV["REDISCLOUD_URL"] || "redis://localhost:6379/")
  $redis = Redis.new(host: uri.host, port: uri.port, password: uri.password)
  def perform(msg="send resource notification to registered user")
    users = User.all
    puts "Load all users"
    users.each do |user|
      topics = user.topics
      topic = topics.sample(1)
      next unless topic[0]
      resources = topic[0].resources
      resource = resources.sample(1)
      username = user.username
      puts $redis.lpush(msg, activate_email(user.email, resource[0].url, topic[0].title, username)) if resource[0]
    end
  end

  def activate_email(recipient, url, topic, username)
    send_mail(recipient, url, topic, username)
  end

  def send_mail(recipient, url, topic, username)
    path = File.expand_path("../views/resource_notification.erb",
                            File.dirname(__FILE__))

    file = ERB.new(File.read(path)).result(binding)
    mailer("Daily Resource Notification", recipient, file)
  end
end
