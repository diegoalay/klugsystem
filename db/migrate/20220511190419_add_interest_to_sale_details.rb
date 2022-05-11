class AddInterestToSaleDetails < ActiveRecord::Migration[6.1]
  def change
    add_column :sale_details, :interest_percentage, :decimal, default: 0
    add_column :sale_details, :interest_value, :decimal, default: 0
  end
end
