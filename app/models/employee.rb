class Employee < ApplicationRecord
  include LoggerConcern

  belongs_to :user,          class_name: "User",    foreign_key: "user_id", optional: true

  has_many :files

  validates :first_name, presence: true
  validates :first_surname, presence: true

  validate  :user_assignment

  def self.index account
    clients = account.employees.select("
      employees.id,
      trim(
        concat(
          employees.first_name,
          ' ',
          employees.second_name
        )
      ) as full_name,
      employees.third_name,
      employees.first_surname,
      employees.second_surname,
      users.email as user_email,
      employees.employee_file_id
    ")
    .left_joins(:user)
  end

  def self.search account, query
    search = query[:filters][:search]&.downcase

    clients = account.employees.select("
      id,
      first_name,
      second_name
      third_name,
      first_surname,
      second_surname,
      users.email as user_email
    ")
    .left_joins(:user)

    clients = clients.where("
      lower(users.email) like '%#{search}%' or
      lower(first_name) like '%#{search}%' or
      lower(last_name) like '%#{search}%' or
      lower(billing_name) like '%#{search}%' or
      lower(billing_identifier) like '%#{search}%' or
      lower(billing_email) like '%#{search}%'
    ") if search
  end

  private

  def user_assignment
    unless user_id.blank?
      # find if there is other employee with this user
      employee = account.employees.where.not(id: id).find_by(
        user_id: user_id
      )

      errors.add(:base, "El usuario ya ha sido tomado") unless employee.blank?
    end
  end
end
