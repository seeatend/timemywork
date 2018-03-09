class AddRatesToMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :time_rate, :integer
    add_column :members, :day_rate, :integer
    add_column :members, :night_rate, :integer
    add_column :members, :time_cost, :integer
    add_column :members, :day_cost, :integer
    add_column :members, :night_cost, :integer
  end
end
