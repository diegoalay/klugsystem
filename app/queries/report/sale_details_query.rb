class Report::SaleDetailsQuery
  def initialize(account)
    @account = account
    @sale_details = account.sales_details
  end

  def index current_user, query
    search = query[:filters][:search]&.downcase

    sale_details = @sale_details.select(
      'sale_details.id',
      'sale_details.created_at',
      'sale_details.total',
      'sale_details.price',
      'sale_details.subtotal',
      'sale_details.quantity',
      'sale_details.subtotal',
      'sale_details.total',
      'sale_details.discount_value',
      'sale_details.discount_percentage',
      'sale_details.measurement_unit',
      'sale_details.product_type',
      'sale_details.interest_percentage',
      'sale_details.interest_value',
      'sale_details.final_subtotal',
      'sale_details.name',
      'sales.sale_type',
      'payment_methods.name as payment_method',
      "concat(users.first_name, ' ', users.first_surname) as user_creator_name",
      "concat(clients.first_name, ' ', clients.first_surname) as client_name",
      'clients.billing_name as client_blling_name',
      'clients.billing_identifier as client_billing_identifier',
      'clients.billing_email as client_billing_email',
      'users.email as user_creator_email',
    )
    .joins(sale: [:client, :user_creator, :payment_method])
    .where("sale_details.status = 'TRUE'")

    unless query[:filters][:user_creator_type].blank?
      sale_details = sale_details.where("sales.user_creator_id = ?", current_user.id) if query[:filters][:user_creator_type].eql? "mine"
    end

    sale_details = sale_details.where("sale_details.product_type = ?", query[:filters][:product_type]) unless query[:filters][:product_type].blank?

    if (query[:filters][:start_date].present? && query[:filters][:end_date].present?)
      sale_details = sale_details.where(
          "sales.created_at >= ? and sales.created_at <= ?",
          "#{DateTime.iso8601(query[:filters][:start_date]).beginning_of_day}",
          "#{DateTime.iso8601(query[:filters][:end_date]).end_of_day}",
      )
    end

    sale_details = sale_details.where("
      lower(sale_details.name) like '%#{search}%' or
      lower(users.first_name) like '%#{search}%' or
      lower(users.first_surname) like '%#{search}%' or
      cast(sale_details.subtotal as varchar) like '%#{search}%' or
      cast(sale_details.total as varchar) like '%#{search}%' or
      cast(sale_details.discount_value as varchar) like '%#{search}%' or
      cast(sale_details.interest_value as varchar) like '%#{search}%' or
      lower(concat(users.first_name, ' ', users.first_surname)) like '%#{search}%'
    ") unless search.blank?

    unless (query[:pagination][:disable])
      sale_details = sale_details.page(query[:pagination][:current_page])
      .per(query[:pagination][:per_page])
      .order("#{query[:pagination][:order_by]} #{query[:pagination][:order]} nulls last")

      data = sale_details.map do |sale|
        sale.attributes.merge(
          sale_type_text: I18n.t("models.sales.column_enum_sale_type_#{sale.sale_type}")
        )
      end

      return Responder.pagination(sale_details, data)
    end

    sale_details
  end

  def show(current_user, query)
    sale_details = self.index(current_user, query)

    if (query[:pagination][:disable])
      valid_sales = sale_details.where(status: true)
      invalid_sales = sale_details.where(status: false)

      return {
        products_count: valid_sales.sum(:quantity),
        valid_sales_count: valid_sales.length,
        valid_sales: valid_sales.sum(:total),
        invalid_sales_count: invalid_sales.length,
        invalid_sales: invalid_sales.sum(:total),
        discounts: valid_sales.sum(:discount_value),
        discounts_count: valid_sales.where("discount != ? or discount != ?", nil, 0).length,
        interests: valid_sales.sum(:interest_value),
        interests_count: valid_sales.where("interest != ? or interest != ?", nil, 0).length
      }
    end

    sale_details
  end

  def options(current_user)
    {
      product_types: Product.product_types.map {|k,_v| {text: I18n.t("models.products.column_enum_product_type_#{k}"), value: k}},
      user_creator_types: [{ text: 'Mis ventas', value: 'mine'}, {text: 'Caja actual', value: 'current_cash_register'}],
      payment_methods: @account.payment_methods.where(status: true).map {|payment_method| {text: payment_method.name, value: payment_method}},
      branch_office: @account.branch_offices.map {|branch_office| {text: branch_office.name, value: branch_office.id}},
      departments: @account.departments.map {|department| {text: department.name, value: department.id}},
      brands: @account.brands.map {|brand| {text: brand.name, value: brand.id}},
      sale_types: ::Sale.fetch_sale_types(current_user)
    }
  end
end