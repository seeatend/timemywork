class AddToCompanyToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :to_company, :string
  end
end
