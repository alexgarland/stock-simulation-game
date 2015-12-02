class Transaction < ActiveRecord::Base
  validates :symbol, presence: true, uniqueness: true
  validates
end
