class AddAmountToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :amount, :integer
  end
end
