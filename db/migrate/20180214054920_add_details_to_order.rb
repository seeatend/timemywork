class AddDetailsToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :starttime, :datetime
    add_column :orders, :endtime, :datetime
  end
end
