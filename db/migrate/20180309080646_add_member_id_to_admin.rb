class AddMemberIdToAdmin < ActiveRecord::Migration[5.1]
  def change
    add_reference :admins, :member, foreign_key: true
  end
end
