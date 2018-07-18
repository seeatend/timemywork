class AddOrderToCredit < ActiveRecord::Migration[5.1]
  def change
    add_reference :credits, :order, foreign_key: true
  end
end
