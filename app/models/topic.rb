require_relative 'user'
require_relative 'user_topic'

class Topic < ActiveRecord::Base
  include ActiveModel::Validations
  validates :title, presence: true, uniqueness: true
  validates :description, presence: true
  has_many :user_topics
  has_many :users, through: :user_topics
end
