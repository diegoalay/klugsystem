class Sale < ApplicationRecord
  acts_as_paranoid

  include LoggerConcern

  belongs_to :client,         class_name: 'Client',        foreign_key: 'client_id'
  belongs_to :employee,       class_name: 'Employee',      foreign_key: 'employee_id', optional: true
  belongs_to :cash_register,  class_name: 'CashRegister',  foreign_key: 'cash_register_id', optional: true
  belongs_to :payment_method, class_name: 'PaymentMethod', foreign_key: 'payment_method_id'
  belongs_to :branch_office,  class_name: 'BranchOffice',  foreign_key: 'branch_office_id'

  has_many   :product_transactions,  foreign_key: 'model_id', as:  :model, class_name: 'Product::Transaction'
  has_many   :details
  has_one    :electronic_bill

  validate :sale_data, on: :create

  after_create  :initialize_sale
  after_save    :rollback_products_edition

  attribute :status, :boolean, default: true

  enum sale_type: {
    sale: 'sale',
    receipt: 'receipt',
    bill: 'bill',
    electronic_bill: 'electronic_bill'
  }

  def rollback_products_edition
    if saved_change_to_status? || saved_change_to_deleted_at?
      before_status, after_status = saved_changes["status"]

      if before_status && !after_status

        if (is_electronic_billing?)
          DigifactServices::Api.new(user_modifier, self).anulate_bill
        end

        ActiveRecord::Base.transaction do
          if (origin != 'bill' && (!is_electronic_billing? || (is_electronic_billing? && electronic_bill&.annulment_datetime.present?)))
            details.each do |sale_detail|
              sale_detail.user_modifier_id = user_modifier_id
              sale_detail.update(status: false)

              if sale_detail.product.present?
                quantity = sale_detail.product.quantity
                quantity += sale_detail.quantity

                sale_detail.product.update(quantity: quantity)

                sale_detail.product.transactions.find_by(model_id: id, model_type: 'Sale')&.destroy!
              end
            end
          end
        end
      end
    end
  end

  def show
    subtotal1_val = subtotal + interest
    subtotal2_val = subtotal1_val - discount

    data = {
      sale: self.attributes.merge({
        'subtotal1' => subtotal1_val.to_f,
        'subtotal2' => subtotal2_val.to_f,
        'sale_type_translated' => I18n.t("models.sales.column_enum_sale_type_#{sale_type}")
      }),
      client: client,
      details: details,
      employee: employee,
      payment_method: payment_method
    }

    if self.is_electronic_billing?
      return data.merge({
        electronic_bill: {
          serie: electronic_bill['certification_data'].dig('Serie'),
          number: electronic_bill['certification_data'].dig('NUMERO'),
          identifier: electronic_bill&.identifier
        }
      })
    end

    data
  end

  def calculations
    {
      subtotal1: subtotal1,
      subtotal2: subtotal2
    }
  end

  def is_electronic_billing?
    sale_type == 'electronic_bill' &&
    electronic_bill &&
    electronic_bill.identifier.present?
  end

  def self.fetch_sale_types(current_user)
    ::Sale.sale_types.each_with_object([]) do |(k, v), sale_types|

      next unless current_user.account.sale_types.include? v
      if k == 'electronic_bill'
        unless current_user.branch_office.electronic_billing? && current_user.account.electronic_billing?
          next
        end
      end

      sale_types.push({
        text: I18n.t("models.sales.column_enum_sale_type_#{k}"),
        value: v
      })
    end
  end

  private

  def initialize_sale
    create_electronic_bill if sale_type == 'electronic_bill'
  end

  def sale_data
    errors.add(:base, 'Debe seleccionar a un empleado.') if (employee.blank? && account.billing_employee_presence.present?)
    errors.add(:base, 'La cantidad recibida debe ser mayor o igual al total de la venta.') if (received_amount < total && origin != 'bill')
    errors.add(:base, 'Debe seleccionar un tipo de venta.') if sale_type.blank?
    errors.add(:base, 'Debe seleccionar un cliente.') if client.blank?
  end
end