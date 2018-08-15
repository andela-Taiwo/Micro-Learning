require "sidekiq"
require "erb"
require "tilt/erb"
require_relative "../../app/helpers/ponymail"

class MailWorker
  include Sidekiq::Worker
  def perform(msg = "send resource", recipient, user, topic)
    $redis.lpush(msg, activate_email(recipient, user, topic))
  end

  def activate_email(recipient, user, topic)
    send_mail(recipient, user, topic)
  end

  # @param [Object] recipient
  # @param [Object] user
  # @param [Object] topic
  def send_mail(recipient, user, topic)
    path = if topic.nil?
             File.expand_path("../views/registration_confirmation.erb", File.dirname(__FILE__))
           else
             File.expand_path("../views/enrollment_message.erb", File.dirname(__FILE__))
           end
    file = ERB.new(File.read(path)).result(binding)
    mailer("Resource Notification", recipient, file)
  end
end
