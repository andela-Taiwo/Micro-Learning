require_relative 'user'
require_relative 'topic'

class UserTopic < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic
end