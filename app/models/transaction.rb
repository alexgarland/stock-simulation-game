class Transaction < ActiveRecord::Base
  validates :symbol, presence: true
end
