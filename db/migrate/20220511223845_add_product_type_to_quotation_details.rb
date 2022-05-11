class AddProductTypeToQuotationDetails < ActiveRecord::Migration[6.1]
  def change
    add_column :quotation_details, :product_type, :string
  end
end
