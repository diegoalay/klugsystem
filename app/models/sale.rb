class Sale < ApplicationRecord
  acts_as_paranoid

  belongs_to :account,       class_name: "Account",      foreign_key: "accounts_id"
  belongs_to :client,        class_name: "Client",       foreign_key: "clients_id"
  belongs_to :user_creator,  class_name: "User",         foreign_key: "user_creator_id"
  belongs_to :user_modifier, class_name: "User",         foreign_key: "user_modifier_id"
  belongs_to :employee,      class_name: "Employee",     foreign_key: "employees_id"
  belongs_to :cash_register, class_name: "CashRegister", foreign_key: "cash_registers_id"

  has_many   :activities, foreign_key: "clients_id"

  validates :first_name, presence: true
  validates :last_name,  presence: true

  include LoggerConcern

  enum sale_type: {
    sale: 'sale',
    bill: 'bill',
    electronic_bill: 'electronic_bill',
    receipt: 'receipt'
  }

  def self.index account, query
    search = query[:filters][:search]

    sales = account.sales.select("
      sales.uuid,
      sales.sale_type,
      sales.discount_value,
      sales.shipping_costs,
      sales.subtotal,
      sales.total,
      sales.sale_date,
      concat(users.first_name, ' ', users.first_surname) as user_creator
    ")
    .joins(:client, :user_creator)
    .left_joins(:employee, :cash_register)

    sales = sales.where("
      lower(sales.uuid) like '%#{search}%' or
      lower(sales.sale_type) like '%#{search}%' or
      lower(users.first_name) like '%#{search}%' or
      lower(users.first_surname) like '%#{search}%' or
      cast(sales.subtotal as varchar) like '%#{search}%' or
      cast(sales.total as varchar) like '%#{search}%' or
      cast(sales.sale_date as varchar) like '%#{search}%'
    ") unless search.blank?

    sales = sales.page(query[:pagination][:current_page])
    .per(query[:pagination][:per_page])
    .order("#{query[:pagination][:order_by]} #{query[:pagination][:order]} nulls last")

    {
      current_page: sales.current_page,
      total_pages: sales.total_pages,
      total_count: sales.total_count,
      total_lenght: sales.length,
      sales: sales
    }
  end

  def self.options account
    {
      payment_methods: account.payment_methods.where(status: true).map {|payment_method| {text: payment_method.name, value: payment_method}},
      branch_office: account.branch_offices.map {|branch_office| {text: branch_office.name, value: branch_office.id}},
      departments: account.departments.map {|department| {text: department.name, value: department.id}},
      brands: account.brands.map {|brand| {text: brand.name, value: brand.id}},
      sale_types: sale_types.map {|k, v| {text: k, value: v}}
    }
  end
end