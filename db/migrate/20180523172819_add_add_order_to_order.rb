class AddAddOrderToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :add_order, :boolean
  end
end
