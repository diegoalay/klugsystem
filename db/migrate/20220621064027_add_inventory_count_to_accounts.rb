class AddInventoryCountToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :inventory_count, :boolean, default: true
  end
end
