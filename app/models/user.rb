
class User < ActiveRecord::Base
  validates :password, presence: true
  validates :email, presence: true
  validates :username, length: {
      minimum: 6,
      maximum: 35,
  }, uniqueness: true
  validates :password, format: {
      with: /\A[a-zA-Z0-9!@#\$%^&\(\)]+\z/,
      message: "only allows a-z, 0-9 and !@#$%^&*()"
  },  length: { minimum: 6, maximum: 35 }
end