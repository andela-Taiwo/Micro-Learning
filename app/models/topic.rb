require_relative 'user'
require_relative 'user_topic'
require_relative 'topic_resources'
require_relative 'resource'

class Topic < ActiveRecord::Base
  include ActiveModel::Validations
  validates :title, presence: true, uniqueness: true
  validates :description, presence: true
  has_many :user_topics
  has_many :users, through: :user_topics
  has_many :topic_resources
  has_many :resources, through: :topic_resources
end
