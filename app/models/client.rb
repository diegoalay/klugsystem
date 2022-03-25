class Client < ApplicationRecord
  include LoggerConcern

  validates :billing_name, presence: true
  validates :billing_address, presence: true
  validates :billing_identifier, presence: true

  before_destroy :can_be_destroyed
  before_save :sanitize_billing_identifier

  def name
    [first_name, first_surname].join(" ")
  end

  private

  def sanitize_billing_identifier
    billing_identifier = billing_identifier&.gsub("-", "")
  end

  def can_be_destroyed
    errors.add(:base, "Existen ventas asignadas a este cliente'") and throw(:abort) unless account.sales.where(client: self).blank?
  end
end