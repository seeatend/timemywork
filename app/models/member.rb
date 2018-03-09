class Member < ApplicationRecord
  has_many :orders
  has_one :admin
end
