class ClientType < ApplicationRecord
  validates :name, presence: true

  belongs_to :client_type, class_name: "ClientType", foreign_key: "client_type_id", optional: true

  include LoggerConcern

  acts_as_paranoid

  before_destroy :can_be_destroyed

  def can_be_destroyed
    errors.add(:base, "Existen clients asignados a este tipo de cliente.") and throw(:abort) unless account.clients.where(client_type: self).blank?
  end
end
