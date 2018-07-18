class AddMemberToOrders < ActiveRecord::Migration[5.1]
  def change
    add_reference :orders, :member, foreign_key: true
  end
end
