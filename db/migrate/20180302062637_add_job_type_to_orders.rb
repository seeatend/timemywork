class AddJobTypeToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :job_type, :string
  end
end
