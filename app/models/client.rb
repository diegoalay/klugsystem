class Client < ApplicationRecord
  include LoggerConcern

  validates :billing_name, presence: true
  validates :billing_address, presence: true
  validates :billing_identifier, presence: true

  before_destroy :can_be_destroyed

  def self.search account, query
    search = query[:filters][:search]&.downcase

    clients = account.clients.select("
      id,
      first_name,
      first_surname,
      billing_identifier,
      billing_email,
      billing_name,
      concat(
        billing_identifier,
        ' [',
        billing_name,
        ']'
      ) as details
    ")

    clients = clients.where("
      lower(first_name) like '%#{search}%' or
      lower(first_surname) like '%#{search}%' or
      lower(second_name) like '%#{search}%' or
      lower(second_surname) like '%#{search}%' or
      lower(billing_name) like '%#{search}%' or
      lower(billing_identifier) like '%#{search}%' or
      lower(billing_email) like '%#{search}%'
    ") if search
  end

  private

  def can_be_destroyed
    errors.add(:base, "Existen ventas asignadas a este cliente'") and throw(:abort) unless account.sales.where(client: self).blank?
  end
end