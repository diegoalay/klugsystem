class AddSaleClientIdToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :sale_client_id, :bigint
    add_foreign_key :accounts, :clients, column: :sale_client_id
  end
end
