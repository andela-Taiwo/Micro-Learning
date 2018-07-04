require_relative 'resource'
require_relative 'topic'

class TopicResource < ActiveRecord::Base
  belongs_to :topic
  belongs_to :resource
end