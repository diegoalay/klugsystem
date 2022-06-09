class Client < ApplicationRecord
  include LoggerConcern

  validates :billing_name, presence: true
  validates :billing_address, presence: true
  validates :billing_identifier, presence: true

  before_destroy :can_be_destroyed
  before_save :sanitize_billing_identifier

  belongs_to :client_type, class_name: "ClientType", foreign_key: "client_type_id", optional: true

  has_many :events

  acts_as_paranoid

  def show
    self.attributes.merge({
      billing_details: billing_details
    })
  end

  def billing_details
    info = billing_identifier
    info += " [ #{billing_name} ]"
  end

  def full_name
    [first_name, first_surname].join(" ")
  end

  private

  def sanitize_billing_identifier
    identifier = self.billing_identifier&.gsub("-", "")
    self.billing_identifier = identifier
  end

  def can_be_destroyed
    errors.add(:base, "Existen ventas asignadas a este cliente") and throw(:abort) unless account.sales.where(client: self).blank?
    errors.add(:base, "El cliente ha sido configurado como predeterminado al momento de realizar una venta") and throw(:abort) unless account.sale_client_id == self.id
  end
end