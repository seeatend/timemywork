class AddFixedTypeToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :fixed_type, :string
  end
end
