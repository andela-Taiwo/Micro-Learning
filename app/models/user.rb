require_relative "topic"
require_relative "user_topic"

class User < ActiveRecord::Base
  include ActiveModel::Validations
  has_many :user_topics
  has_many :topics, through: :user_topics
  before_create :confirmation_token
  has_secure_password
  validates :password_confirmation, presence: true
  validates :email, presence: true
  validates :username, length: {
    minimum: 4,
    maximum: 35,
  }, uniqueness: true
  validates :password, format: {
    with:    /\A[a-zA-Z0-9!@#\$%^&\(\)]+\z/,
    message: "only allows a-z, 0-9 and !@#$%^&*()",
  }, length: { minimum: 6, maximum: 35 }

  private

  def confirmation_token
    self.confirm_token = SecureRandom.urlsafe_base64.to_s if confirm_token.blank?
  end
end
