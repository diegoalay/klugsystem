class Sale < ApplicationRecord
  include LoggerConcern

  belongs_to :client,         class_name: "Client",        foreign_key: "client_id"
  belongs_to :user_creator,   class_name: "User",          foreign_key: "user_creator_id"
  belongs_to :user_modifier,  class_name: "User",          foreign_key: "user_modifier_id"
  belongs_to :employee,       class_name: "Employee",      foreign_key: "employee_id", optional: true
  belongs_to :cash_register,  class_name: "CashRegister",  foreign_key: "cash_register_id", optional: true
  belongs_to :payment_method, class_name: "PaymentMethod", foreign_key: "payment_method_id"

  has_many   :product_transactions,  foreign_key: "model_id", as:  :model, class_name: "Product::Transaction"
  has_many   :details,               foreign_key: "sale_id"

  validate :sale_data

  enum sale_type: {
    sale: 'sale',
    receipt: 'receipt',
    bill: 'bill',
    electronic_bill: 'electronic_bill'
  }

  def show
    {
      sale: self.attributes.merge({
        sale_type: I18n.t("models.sales.column_enum_sale_type_#{sale_type}")
      }),
      client: client,
      details: details,
      employee: employee,
      payment_method: payment_method
    }
  end
  
  private

  def sale_data
    errors.add(:base, "La cantidad recibida debe ser mayor o igual al total de la venta.") if (received_amount < total)
    errors.add(:base, "Debe seleccionar un tipo de venta.") if sale_type.blank?
  end
end