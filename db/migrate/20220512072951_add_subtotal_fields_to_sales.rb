class AddSubtotalFieldsToSales < ActiveRecord::Migration[6.1]
  def change
    add_column :sales, :subtotal1, :decimal # subtotal + interest
    add_column :sales, :subtotal2, :decimal # subtotal1 - discount
  end
end
