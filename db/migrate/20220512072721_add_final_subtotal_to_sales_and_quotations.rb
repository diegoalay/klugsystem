class AddFinalSubtotalToSalesAndQuotations < ActiveRecord::Migration[6.1]
  def change
    add_column :sale_details, :final_subtotal, :decimal
    add_column :quotation_details, :final_subtotal, :decimal

    Sale::Detail.all.each do |sale_detail|
      sale_detail.update(final_subtotal: sale_detail.subtotal)
    end

    Quotation::Detail.all.each do |quotation_detail|
      quotation_detail.update(final_subtotal: quotation_detail.subtotal)
    end
  end
end
