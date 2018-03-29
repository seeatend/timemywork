class AddPasswordToMembers < ActiveRecord::Migration[5.1]
  def change
    add_column :members, :password, :string
  end
end
