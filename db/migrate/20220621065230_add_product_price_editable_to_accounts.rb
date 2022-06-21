class AddProductPriceEditableToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :product_price_editable, :boolean, default: false
  end
end
