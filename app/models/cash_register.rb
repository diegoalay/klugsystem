class CashRegister < ApplicationRecord
  include LoggerConcern

  has_many :sales, class_name: "Sale", foreign_key: "cash_register_id"
  has_many :expeditures, class_name: "Expediture", foreign_key: "cash_register_id"

  validates :open_date, presence: true

  def self.index account, query
    search = query[:filters][:search]&.downcase

    cash_registers = account.cash_registers.select("
      cash_registers.id,
      cash_registers.initial_value,
      cash_registers.final_value,
      cash_registers.open_date,
      cash_registers.close_date,
      concat(users.first_name, ' ', users.first_surname) as user_creator_name
    ")
    .joins(:user_creator)

    cash_registers = cash_registers.where("
      cast(cash_registers.initial_value as varchar) like '%#{search}%' or
      cast(cash_registers.final_value as varchar) like '%#{search}%' or
      lower(concat(users.first_name, ' ', users.first_surname)) like '%#{search}%' or
      lower(users.first_name) like '%#{search}%' or
      lower(users.first_surname) like '%#{search}%'
    ") unless search.blank?

    if (query[:filters][:start_date].present? && query[:filters][:end_date].present?)
        cash_registers = cash_registers.where(
            "cash_registers.open_date >= ? and cash_register.close_date <= ?",
            query[:filters][:start_date],
            query[:filters][:end_date],
        )
    end

    cash_registers = cash_registers.where(
      "cash_registers.close_date is null"
    ) if (!query[:filters][:cash_register_status].blank? && query[:filters][:cash_register_status] == "open")

    cash_registers = cash_registers.where(
      "cash_registers.close_date is not null"
    ) if (!query[:filters][:cash_register_status].blank? && query[:filters][:cash_register_status] == "close")

    cash_registers = cash_registers.page(query[:pagination][:current_page])
    .per(query[:pagination][:per_page])
    .order("#{query[:pagination][:order_by]} #{query[:pagination][:order]} nulls last")

    {
      current_page: cash_registers.current_page,
      total_pages: cash_registers.total_pages,
      total_count: cash_registers.total_count,
      total_lenght: cash_registers.length,
      cash_registers: cash_registers
    }
  end

  def show
    sales_sum = sales.where(cash_register: self).sum(:total)&.to_f
    expeditures_sum = expeditures.where(cash_register: self).sum(:amount)&.to_f

    sum_final_value = 0

    if close_date.present?
      sum_final_value = final_value
    else
      sum_final_value = sum_final_value()
    end

    chart = {
      series: [sales_sum, expeditures_sum],
      labels: ["Ventas", "Gastos"]
    }

    {
      id: id,
      chart: chart,
      open_date: open_date,
      close_date: close_date,
      initial_value: initial_value.to_f,
      final_value: sum_final_value,
      closed: close_date.blank? ? false : true,
      details: {
        sales: sales,
        expeditures: expeditures
      }
    }
  end

  def sum_final_value
    sales_sum = sales.sum(:total)&.to_f
    expeditures_sum = expeditures.sum(:amount)&.to_f

    return (initial_value + sales_sum - expeditures_sum)
  end
end