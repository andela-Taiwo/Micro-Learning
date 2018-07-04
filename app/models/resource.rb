require_relative 'topic'
require_relative 'topic_resources'

class Resource < ActiveRecord::Base
  include ActiveModel::Validations
  validates :title, presence: true, uniqueness: true
  validates :description, presence: true
  has_many :topic_resources
  has_many :topics, through: :topic_resources
end
