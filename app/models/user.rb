class User < ActiveRecord::Base
  before_create :confirmation_token
  has_secure_password
  validates :password_digest, presence: true
  validates :password_confirmation, presence: true
  validates :email, presence: true
  validates :username, length: {
      minimum: 4,
      maximum: 35,
  }, uniqueness: true
  validates :password, format: {
      with: /\A[a-zA-Z0-9!@#\$%^&\(\)]+\z/,
      message: "only allows a-z, 0-9 and !@#$%^&*()"
  },  length: { minimum: 6, maximum: 35 }

  private
  def confirmation_token
    if self.confirm_token.blank?
      self.confirm_token = SecureRandom.urlsafe_base64.to_s
    end
  end

end