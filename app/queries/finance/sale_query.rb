class Finance::SaleQuery 
  def initialize(account)
    @account = account
    @sales = account.sales 
  end

  def index current_user, query
    search = query[:filters][:search]&.downcase

    sales = @sales.select("
      sales.id,
      sales.uuid,
      sales.sale_type,
      sales.discount,
      sales.shipping_costs,
      sales.subtotal,
      sales.total,
      sales.discount,
      sales.interest,
      sales.received_amount,
      sales.change,
      sales.sale_date,
      concat(employees.first_name, ' ', employees.first_surname) as employee_name,
      concat(users.first_name, ' ', users.first_surname) as user_creator_name,
      concat(clients.first_name, ' ', clients.first_surname) as client_name,
      clients.billing_name as client_blling_name,
      clients.billing_identifier as client_billing_identifier,
      users.email as user_creator_email
    ")
    .joins(:client, :user_creator)
    .left_joins(:employee, :cash_register)

    sales = sales.where("
      lower(sales.uuid) like '%#{search}%' or
      lower(sales.sale_type) like '%#{search}%' or
      lower(users.first_name) like '%#{search}%' or
      lower(users.first_surname) like '%#{search}%' or
      lower(employees.first_name) like '%#{search}%' or
      lower(employees.first_surname) like '%#{search}%' or
      cast(sales.subtotal as varchar) like '%#{search}%' or
      cast(sales.total as varchar) like '%#{search}%' or
      cast(sales.sale_date as varchar) like '%#{search}%' or
      lower(clients.billing_name) like '%#{search}%' or
      lower(clients.billing_identifier) like '%#{search}%' or
      lower(concat(users.first_name, ' ', users.first_surname)) like '%#{search}%' or
      lower(concat(employees.first_name, ' ', employees.first_surname)) like '%#{search}%'
    ") unless search.blank?

    unless query[:filters][:user_creator_type].blank?
      sales = sales.where("sales.user_creator_id = ?", current_user.id) if query[:filters][:user_creator_type].eql? "mine"
      sales = sales.where("sales.cash_register_id = ?", current_user.cash_register&.id) if query[:filters][:user_creator_type].eql? "current_cash_register"
    end

    sales = sales.where("sales.sale_type = ?", query[:filters][:sale_type]) unless query[:filters][:sale_type].blank?
    sales = sales.where("sales.payment_method_id = ?", query[:filters][:payment_method]) unless query[:filters][:payment_method].blank?
    sales = sales.where("sales.cash_register_id = ?", query[:filters][:cash_register_id]) unless query[:filters][:cash_register_id].blank?

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

  def index_options
    {
      user_creator_types: [{ text: 'Mis ventas', value: 'mine'}, {text: 'Caja actual', value: 'current_cash_register'}],
      payment_methods: @account.payment_methods.map {|payment_method| {text: payment_method.name, value: payment_method.id}},
      sale_types: sale_types
    }
  end

  def options
    {
      payment_methods: @account.payment_methods.where(status: true).map {|payment_method| {text: payment_method.name, value: payment_method}},
      branch_office: @account.branch_offices.map {|branch_office| {text: branch_office.name, value: branch_office.id}},
      departments: @account.departments.map {|department| {text: department.name, value: department.id}},
      brands: @account.brands.map {|brand| {text: brand.name, value: brand.id}},
      sale_types: sale_types
    }
  end

  def sale_types 
    Sale.sale_types.map {|k, v| {text: I18n.t("models.sales.column_enum_sale_type_#{k}"), value: v}}
  end
end