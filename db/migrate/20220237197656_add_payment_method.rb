class AddPaymentMethod < ActiveRecord::Migration[6.1]
  def change
    add_reference   :sales, :payment_methods,     foreign_key: true
  end
end
