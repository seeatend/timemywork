class CreateRegistrationTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :registration_tokens do |t|
      t.string :token

      t.timestamps
    end
  end
end
