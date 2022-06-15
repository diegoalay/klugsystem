class AddSaleTypesToAccount < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :sale_types, :jsonb
  end
end
