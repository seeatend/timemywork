class AddCreditorToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :creditor_name, :string
  end
end
