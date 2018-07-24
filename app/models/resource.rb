require_relative "topic"
require_relative "topic_resources"

class Resource < ActiveRecord::Base
  include ActiveModel::Validations
  validates :title, presence: true, uniqueness: true,
                    length: {minimum: 6, maximum: 45}
  validates :description, presence: true, length: {minimum: 10, maximum: 250}
  validates :url, presence: true, length: {minimum: 7, maximum: 100}
  has_many :topic_resources
  has_many :topics, through: :topic_resources
end
