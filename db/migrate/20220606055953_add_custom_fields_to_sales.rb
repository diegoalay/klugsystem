class AddCustomFieldsToSales < ActiveRecord::Migration[6.1]
  def change
    add_column :sales, :custom_fields, :jsonb, default: []
  end
end
