class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.integer :rate_per_hour

      t.timestamps
    end
  end
end
