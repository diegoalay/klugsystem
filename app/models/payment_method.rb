class PaymentMethod < ApplicationRecord
  belongs_to :account,       class_name: "Account", foreign_key: "accounts_id"
  belongs_to :user_creator,  class_name: "User",    foreign_key: "user_creator_id"
  belongs_to :user_modifier, class_name: "User",    foreign_key: "user_modifier_id"

  has_many   :activities, foreign_key: "payment_methods_id", dependent: :destroy

  validates :name, presence: true
  validate  :uniqueness_name

  include LoggerConcern

  before_save :sanitize_name
  before_destroy :can_be_destroyed

  private

  def can_be_destroyed
    errors.add(:base, "Existen productos asignadas a este departamento") and throw(:abort) unless account.sales.where(payment_method: self).blank?
  end

  def uniqueness_name
    payment_method = account.payment_methods.where.not(id: id).find_by(name: name)

    errors.add(:base, "Este método de pago ya se encuentra en el sistema.") unless payment_method.blank?
  end

  def sanitize_name
    self.name = self.name&.downcase
  end
end
