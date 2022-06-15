class AddOriginToSales < ActiveRecord::Migration[6.1]
  def change
    add_column :sales, :origin, :string, default: 'sale'
  end
end
