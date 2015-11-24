class User < ActiveRecord::Base
  validates :username, presence: true, uniqueness: true
  EMAIL_FORMAT = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, :uniqueness => { :case_sensitive => false}, format: {with: EMAIL_FORMAT}
  has_secure_password
  validates :password, presence: true
end
