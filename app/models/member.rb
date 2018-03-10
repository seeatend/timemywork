class Member < ApplicationRecord
  has_many :orders
  has_one :admin
  validates :name, :email, :time_rate, :day_rate, :night_rate, :time_cost, :day_cost, :night_cost, :fixed_rate, presence: true
end
