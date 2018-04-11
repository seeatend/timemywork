# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Product.create!([
  { name: 'Product 001' },
  { name: 'Product 002' },
  { name: 'Product 003' },
  { name: 'Product 004' }
])
Customer.create!([
  { name: 'Customer 001' },
  { name: 'Customer 002' },
  { name: 'Customer 003' },
  { name: 'Customer 004' }
])
User.create!([
  { name: 'User 001' },
  { name: 'User 002' },
  { name: 'User 003' },
  { name: 'User 004' }
])
Order.create!([
  { reference: 'ORD001', user_id: 1, starttime: Time.now - 10.hours, endtime: Time.now - 5.hours },
  { reference: 'ORD002', user_id: 1, starttime: Time.now - 10.hours, endtime: Time.now - 5.hours },
  { reference: 'ORD003', user_id: 1, starttime: Time.now - 10.hours, endtime: Time.now - 5.hours },
  { reference: 'ORD004', user_id: 1, starttime: Time.now - 10.hours, endtime: Time.now - 5.hours },
  { reference: 'ORD005', user_id: 1, starttime: Time.now - 10.hours, endtime: Time.now - 5.hours }
])

# name, :email, :time_rate, :day_rate, :night_rate, :time_cost, :day_cost, :night_cost, :fixed_rate
