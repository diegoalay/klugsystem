class Quotation < ApplicationRecord
  include LoggerConcern

  belongs_to :payment_method, class_name: 'PaymentMethod', foreign_key: 'payment_method_id'
  belongs_to :branch_office,  class_name: 'BranchOffice',  foreign_key: 'branch_office_id'
  belongs_to :employee,       class_name: 'Employee',      foreign_key: 'employee_id', optional: true

  has_many   :details, dependent: :destroy

  validate :quotation_data

  acts_as_paranoid

  def show
    subtotal1 = subtotal - discount
    subtotal2 = subtotal1 + interest

    {
      quotation: self.attributes.merge({
        'subtotal1' => subtotal1.to_f,
        'subtotal2' => subtotal2.to_f,
        'quotation_type_translated' => I18n.t("models.sales.column_enum_sale_type_#{quotation_type}")
      }),
      details: details,
      employee: employee,
      payment_method: payment_method
    }
  end

  def quotation_data
    errors.add(:base, 'La cantidad recibida debe ser mayor o igual al total de la venta.') if (received_amount < total)
    errors.add(:base, 'Debe ingresar un nombre de cliente.') if client_name.blank?
  end
end
