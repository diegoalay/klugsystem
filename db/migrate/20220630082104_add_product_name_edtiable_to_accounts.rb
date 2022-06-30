class AddProductNameEdtiableToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :product_name_editable, :boolean, default: false
  end
end
