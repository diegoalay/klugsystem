class Sale < ApplicationRecord
  include LoggerConcern

  belongs_to :client,         class_name: 'Client',        foreign_key: 'client_id'
  belongs_to :employee,       class_name: 'Employee',      foreign_key: 'employee_id', optional: true
  belongs_to :cash_register,  class_name: 'CashRegister',  foreign_key: 'cash_register_id', optional: true
  belongs_to :payment_method, class_name: 'PaymentMethod', foreign_key: 'payment_method_id'
  belongs_to :branch_office,  class_name: 'BranchOffice',  foreign_key: 'branch_office_id'

  has_many   :product_transactions,  foreign_key: 'model_id', as:  :model, class_name: 'Product::Transaction'
  has_many   :details
  has_one    :electronic_bill

  validate :sale_data

  after_create :initialize_sale
  after_save :rollback_products

  attribute :status, :boolean, default: true

  enum sale_type: {
    sale: 'sale',
    receipt: 'receipt',
    bill: 'bill',
    electronic_bill: 'electronic_bill'
  }

  def rollback_products
    if saved_change_to_status?
      before, after = saved_changes["status"]

      if before && !after
        ActiveRecord::Base.transaction do
          details.each do |sale_detail|
            sale_detail.user_modifier_id = user_modifier_id
            sale_detail.update(status: false)

            if sale_detail.product.present?
              quantity = sale_detail.product.quantity
              quantity += sale_detail.quantity

              sale_detail.product.update(quantity: quantity)
            end
          end
        end
      end
    end
  end

  def show
    subtotal1 = subtotal - discount
    subtotal2 = subtotal1 + interest

    {
      sale: self.attributes.merge({
        'subtotal1' => subtotal1.to_f,
        'subtotal2' => subtotal2.to_f,
        'sale_type' => I18n.t("models.sales.column_enum_sale_type_#{sale_type}")
      }),
      client: client,
      details: details,
      employee: employee,
      payment_method: payment_method
    }
  end

  def calculations
    {
      subtotal1: subtotal1,
      subtotal2: subtotal2
    }
  end

  def is_electronic_billing?
    sale_type == 'electronic_bill'
  end

  private

  def initialize_sale
    create_electronic_bill if sale_type == 'electronic_bill'
  end

  def sale_data
    errors.add(:base, 'Debe seleccionar al menos un producto.') if (subtotal == 0)
    errors.add(:base, 'La cantidad recibida debe ser mayor o igual al total de la venta.') if (received_amount < total)
    errors.add(:base, 'Debe seleccionar un tipo de venta.') if sale_type.blank?
    errors.add(:base, 'Debe seleccionar un cliente.') if client.blank?
  end
end