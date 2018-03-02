class CreateAccount < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.integer :sales
      t.integer :costs
      t.integer :gross_profit
    end
  end
end
