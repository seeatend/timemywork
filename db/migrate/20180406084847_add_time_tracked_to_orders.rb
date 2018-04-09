class AddTimeTrackedToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :time_tracked, :boolean
  end
end
