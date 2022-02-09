class Client < ApplicationRecord
  belongs_to :account,       class_name: "Account", foreign_key: "accounts_id"
  belongs_to :user_creator,  class_name: "User",    foreign_key: "user_creator_id"
  belongs_to :user_modifier, class_name: "User",    foreign_key: "user_modifier_id"

  has_many   :activities, foreign_key: "clients_id"

  validates :first_name, presence: true
  validates :first_surname,  presence: true

  before_destroy :can_be_destroyed

  include LoggerConcern

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