class AddDigifactJsonToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :digifact, :jsonb, default: {}
  end
end
