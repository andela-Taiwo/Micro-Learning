require_relative "user"
require_relative "user_topic"
require_relative "topic_resources"
require_relative "resource"

class Topic < ActiveRecord::Base
  include ActiveModel::Validations
  validates :title, presence: true, uniqueness: true,
                    length: { minimum: 6, maximum: 45 }
  validates :description, presence: true, length: { minimum: 10, maximum: 250 }
  has_many :user_topics
  has_many :users, through: :user_topics
  has_many :topic_resources
  has_many :resources, through: :topic_resources
end
