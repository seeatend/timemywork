class CreateCredit < ActiveRecord::Migration[5.1]
  def change
    create_table :credits do |t|
      t.string :name
      t.integer :amount
      t.string :status
      t.string :description
    end
  end
end
