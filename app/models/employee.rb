class Employee < ApplicationRecord
  acts_as_paranoid

  belongs_to :account,       class_name: "Account", foreign_key: "accounts_id"
  belongs_to :user_creator,  class_name: "User",    foreign_key: "user_creator_id"
  belongs_to :user_modifier, class_name: "User",    foreign_key: "user_modifier_id"

  has_many   :activities, foreign_key: "employees_id"

  validates :first_name, presence: true
  validates :first_surname, presence: true
  validate  :user_assignment

  include LoggerConcern

  def self.search account, query
    search = query[:filters][:search]&.downcase

    clients = account.employees.select("
      id,
      first_name,
      second_name
      third_name,
      first_surname,
      second_surname
    ")

    clients = clients.where("
      lower(first_name) like '%#{search}%' or
      lower(last_name) like '%#{search}%' or
      lower(billing_name) like '%#{search}%' or
      lower(billing_identifier) like '%#{search}%' or
      lower(billing_email) like '%#{search}%'
    ") if search
  end

  private

  def user_assignment
    unless users_id.blank?
      # find if there is other employee with this user
      employee = account.employees.where.not(id: id).find_by(
        users_id: users_id
      )

      self.errors.add_to_base(:base, "El usuario ya ha sido tomado") unless employee.blank?
    end
  end
end
