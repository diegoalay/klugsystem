class CashRegister < ApplicationRecord
  include LoggerConcern

  validates :open_date, presence: true

  def self.index account, query
    search = query[:filters][:search]&.downcase

    cash_register = account.cash_registers.select("
      cash_registers.id,
      cash_registers.initial_value,
      cash_registers.final_value,
      cash_registers.open_date,
      cash_registers.close_date,
      concat(users.first_name, ' ', users.first_surname) as user_creator_name
    ")
    .joins(:user_creator)

    cash_register = cash_register.where("
      cast(cash_register.initial_value as varchar) like '%#{search}%' or
      cast(cash_register.final_value as varchar) like '%#{search}%' or
      lower(concat(users.first_name, ' ', users.first_surname)) like '%#{search}%' or
      lower(users.first_name) like '%#{search}%' or
      lower(users.first_surname) like '%#{search}%'
    ") unless search.blank?

    cash_register = cash_register.page(query[:pagination][:current_page])
    .per(query[:pagination][:per_page])
    .order("#{query[:pagination][:order_by]} #{query[:pagination][:order]} nulls last")

    {
      current_page: cash_register.current_page,
      total_pages: cash_register.total_pages,
      total_count: cash_register.total_count,
      total_lenght: cash_register.length,
      cash_register: cash_register
    }
  end
end
