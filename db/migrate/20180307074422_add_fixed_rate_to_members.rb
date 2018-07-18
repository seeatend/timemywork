class AddFixedRateToMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :fixed_rate, :integer
    add_column :members, :fixed_cost, :integer
  end
end
