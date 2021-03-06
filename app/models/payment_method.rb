class PaymentMethod < ApplicationRecord
  include LoggerConcern

  validates :name, presence: true
  validate  :uniqueness_name

  before_save :sanitize_name
  before_destroy :can_be_destroyed

  acts_as_paranoid

  enum category: {
    discount: 'discount',
    interest: 'interest'
  }

  def self.options(account)
    {
      categories: PaymentMethod.categories.map {|k, v| { text: I18n.t("models.payment_methods.column_enum_category_#{k}"), value: v}}
    }
  end

  private

  def can_be_destroyed
    errors.add(:base, "Existen ventas asignadas a este método de pago") and throw(:abort) unless account.sales.where(payment_method: self).blank?
  end

  def uniqueness_name
    payment_method = account.payment_methods.where.not(id: id).find_by(name: name)

    errors.add(:base, "Este método de pago ya se encuentra en el sistema.") unless payment_method.blank?
  end

  def sanitize_name
    self.name = self.name&.downcase
  end
end
