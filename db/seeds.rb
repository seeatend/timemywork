# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# Product.create!([
#                                     { name: 'Product 001' },
#                                     { name: 'Product 002' },
#                                     { name: 'Product 003' },
#                                     { name: 'Product 004' }
#                                 ])
# Customer.create!([
#                      { name: 'Customer 001' },
#                      { name: 'Customer 002' },
#                      { name: 'Customer 003' },
#                      { name: 'Customer 004' }
#                  ])
# Order.delete_all

100.times.each { |i|
      Order.create!({
                        reference: "ORD00#{i}",
                        user_id: 1,
                        cost: 6*i,
                        amount: 8*i ,
                        starttime: i.days.ago - 10.hours,
                      endtime: i.days.ago - 5.hours,
                      member_id: 2
                    })
}



# name, :email, :time_rate, :day_rate, :night_rate, :time_cost, :day_cost, :night_cost, :fixed_rate
