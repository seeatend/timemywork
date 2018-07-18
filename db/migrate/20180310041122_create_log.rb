class CreateLog < ActiveRecord::Migration[5.1]
  def change
    create_table :logs do |t|
      t.integer :orderid
      t.string :user_name
      t.datetime :starttime
      t.datetime :endtime
      t.string :amount
      t.string :job_type
      t.integer :cost
      t.string :fixed_type
    end
  end
end
