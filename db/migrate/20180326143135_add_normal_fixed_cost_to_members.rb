class AddNormalFixedCostToMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :normal_fixed_cost, :integer
    add_column :members, :hotel_fixed_cost, :integer
  end
end
