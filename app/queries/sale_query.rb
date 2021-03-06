class SaleQuery
  def initialize(account)
    @account = account
    @sales = account.sales
  end

  def index current_user, query
    search = query[:filters][:search]&.downcase

    sales = @sales.select(
      'sales.id',
      'sales.uuid',
      'sales.sale_type',
      'sales.discount',
      'sales.shipping_costs',
      'sales.subtotal',
      'sales.total',
      'sales.interest',
      'sales.received_amount',
      'sales.change',
      'sales.status',
      'sales.sale_date',
      'payment_methods.name as payment_method',
      "concat(employees.first_name, ' ', employees.second_name, ' ', employees.first_surname, ' ', employees.second_surname) as employee_name",
      "concat(users.first_name, ' ', users.first_surname) as user_creator_name",
      "concat(clients.first_name, ' ', clients.first_surname) as client_name",
      'clients.billing_name as client_blling_name',
      'clients.billing_identifier as client_billing_identifier',
      'clients.billing_email as client_billing_email',
      'users.email as user_creator_email',
      'sales.created_at'
    )
    .joins(:client, :user_creator, :payment_method)
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
      sales = sales.where("sales.cash_register_id = ?", current_user.current_cash_register&.id) if query[:filters][:user_creator_type].eql? "current_cash_register"
    end

    if (query[:filters][:start_date].present? && query[:filters][:end_date].present?)
      sales = sales.where(
          "sales.created_at >= ? and sales.created_at <= ?",
          "#{DateTime.iso8601(query[:filters][:start_date]).beginning_of_day}",
          "#{DateTime.iso8601(query[:filters][:end_date]).end_of_day}",
      )
    end

    sales = sales.where("sales.employee_id = ?", query[:filters][:employee_id]) unless query[:filters][:employee_id].blank?
    sales = sales.where("sales.origin = ?", query[:filters][:origin]) unless query[:filters][:origin].blank?
    sales = sales.where("sales.sale_type = ?", query[:filters][:sale_type]) unless query[:filters][:sale_type].blank?
    sales = sales.where("sales.payment_method_id = ?", query[:filters][:payment_method]) unless query[:filters][:payment_method].blank?
    sales = sales.where("sales.cash_register_id = ?", query[:filters][:cash_register_id]) unless query[:filters][:cash_register_id].blank?
    sales = sales.where("sales.status = ?", query[:filters][:status]) unless query[:filters][:status].blank?

    unless (query[:pagination][:disable])
      sales = sales.page(query[:pagination][:current_page])
      .per(query[:pagination][:per_page])
      .order("#{query[:pagination][:order_by]} #{query[:pagination][:order]} nulls last")

      data = sales.map do |sale|
        sale.attributes.merge(
          employee_name: sale.employee_name&.squish,
          can_be_disabled: sale.status ? current_user.admin? : false,
          sale_type_text: I18n.t("models.sales.column_enum_sale_type_#{sale.sale_type}")
        )
      end

      return Responder.pagination(sales, data)
    end

    return sales
  end

  def options(current_user, query)
    filters = query[:filters]||{}

    if filters[:action] === 'index'
      payment_methods = @account.payment_methods.map {|payment_method| { text: payment_method.name, value: payment_method.id }}
    else
      payment_methods = @account.payment_methods
                                .where(status: true)
                                .map {|payment_method| {
                                    text: payment_method.name,
                                    value: payment_method
                                  }
                                }
    end

    {
      product_types: Product.product_types.map { |k,_v|
        {
          text: I18n.t("models.products.column_enum_product_type_#{k}").split('')[0],
          value: k
        }
      },
      measurement_units: @account.measurement_units
                        .map {|measurement_unit| {text: measurement_unit.name, value: Product.measurement_unit_parser(measurement_unit.name)}},
      statuses: [{text: 'Activa', value: true }, {text: 'Anulada', value: false }],
      user_creator_types: [{ text: 'Mis ventas', value: 'mine'}, {text: 'Caja actual', value: 'current_cash_register'}],
      payment_methods: payment_methods,
      branch_office: @account.branch_offices.map {|branch_office| {text: branch_office.name, value: branch_office.id}},
      departments: @account.departments.map {|department| {text: department.name, value: department.id}},
      brands: @account.brands.map {|brand| {text: brand.name, value: brand.id}},
      sale_types: ::Sale.fetch_sale_types(current_user),
      billing_fields: @account.billing_fields,
      sale_client_id: @account.sale_client_id,
      billing_employee_presence: @account.billing_employee_presence,
      product_price_editable: @account.product_price_editable,
      product_name_editable: @account.product_name_editable,
      inventory_count: @account.inventory_count,
      employees: @account.employees.map {|employee| {text: employee.name, value: employee.id}}
    }
  end
end