class Product < ApplicationRecord
  include LoggerConcern

  belongs_to :brand, optional: :true
  belongs_to :department, optional: :true
  belongs_to :branch_office
  belongs_to :measurement_unit

  has_many :sale_details,  class_name: "Sale::Detail", foreign_key: "product_id"
  has_many :transactions

  has_many :files

  validates :name, presence: true
  validates :retail_price, presence: true
  validates :product_type, presence: true

  before_destroy :can_be_destroyed
  attribute :product_type, :string, default: 'good'

  enum product_type: {
    good: 'good',
    service: 'service',
  }

  def self.index account, query
    search = query[:filters][:search]&.downcase if query[:filters]

    products = account.products.select("
      products.id,
      products.sku,
      products.name,
      products.retail_price,
      products.wholesale_price,
      products.quantity,
      products.product_file_id,
      products.product_type,
      brands.name as brand_name,
      measurement_units.name as measurement_unit_name,
      case
        when products.quantity <= 0 then 'Agotado'
        else 'Disponible'
      end as status
    ")
    .joins(:branch_office)
    .left_joins(:brand, :department, :measurement_unit)

    products = products.where("
      lower(products.status) like '%#{search}%' or
      lower(products.sku) like '%#{search}%' or
      lower(products.name) like '%#{search}%' or
      cast(products.retail_price as varchar) like '%#{search}%' or
      cast(products.wholesale_price as varchar) like '%#{search}%' or
      cast(products.quantity as varchar) like '%#{search}%'
    ") unless search.blank?

    products = products.where("products.product_type = ?", query[:filters][:product_type]) if query[:filters] && !query[:filters][:product_type].blank?

    if (query[:filters] && !!query[:filters][:top_products])
      return [] if (query[:filters][:start_date].blank?||query[:filters][:end_date].blank?)

      # most seller products in the last 30 days
      return products
      .group(
        "products.id",
        "products.sku",
        "products.name",
        "products.retail_price",
        "products.wholesale_price",
        "products.quantity",
        "products.product_file_id",
        "products.product_type",
        "brands.name",
        "measurement_units.name"
      )
      .select("count(*) as sales")
      .joins("
        inner join sale_details
          on sale_details.product_id = products.id
        inner join sales
          on sales.id = sale_details.sale_id
          and sales.created_at >= '#{query[:filters][:start_date]}'
          and date(sales.created_at) <= '#{query[:filters][:end_date]}'
      ")
      .where("products.quantity > ?", 0)
      .order("sales desc")
      .limit(16)
    end

    products = products.page(query[:pagination][:current_page])
    .per(query[:pagination][:per_page])
    .order("#{query[:pagination][:order_by]} #{query[:pagination][:order]} nulls last")

    {
      current_page: products.current_page,
      total_pages: products.total_pages,
      total_count: products.total_count,
      total_lenght: products.length,
      products: products.map do |product|
        product.attributes.merge(
          product_type_translation: I18n.t("models.products.column_enum_product_type_#{product.product_type}")
        )
      end
    }
  end

  def self.search account, query
    filters = query[:filters]
    search = filters[:search]&.downcase

    products = account.products.select("
      products.id,
      products.name,
      retail_price,
      wholesale_price,
      retail_price,
      products.quantity,
      brands.name as brand_name,
      departments.name as department_name,
      branch_offices.name as branch_office_name,
      measurement_units.name as measurement_unit_name,
      concat(
        products.name,
        ' [',
        products.sku,
        ']'
      ) as details,
      products.product_file_id
    ")
    .joins(:branch_office)
    .left_joins(:brand, :department, :measurement_unit)

    products = products.where("
      lower(products.sku) like '%#{search}%' or
      lower(products.name) like '%#{search}%'
    ") if search

    products = products.where("brand_id = ? ", filters[:brand_id]) if filters[:brand_id]
    products = products.where("department_id = ? ", filters[:department_id]) if filters[:department_id]
    products = products.where("branch_office_id = ? ", filters[:branch_office_id]) if filters[:branch_office_id]

    products
  end

  def sale_statistics
    statistics = self.account.sales_details.joins(:sale).where(product: self, status: true)
    .select(
        "sum(sale_details.quantity) as total",
        "to_char(sales.sale_date, 'MM') as month",
        "to_char(sales.sale_date, 'YYYY') as year"
    )
    .group(
        "to_char(sales.sale_date, 'MM')",
        "to_char(sales.sale_date, 'YYYY')"
    )

    data = {}

    years = [Time.current.year.to_i]
    years.concat(statistics.map{|statistic| statistic.year.to_i })
    years = years.uniq

    years.each do |year|
        data[year] = [] if data[year].blank?

        (1..12).each do |month|
            sales = statistics.find {|statistic|
                statistic["month"].to_i == month.to_i &&
                statistic["year"].to_i == year.to_i }

            data[year].push(sales ? sales["total"].to_f : 0)
        end
    end

    data
  end

  def show
    product = self.attributes.merge({
      details: name.to_s + " [" + sku.to_s + "]",
      statistics: self.sale_statistics
    })

    product
  end

  def self.options account
    {
      product_types: product_types.map {|k,_v| {text: I18n.t("models.products.column_enum_product_type_#{k}"), value: k}},
      measurement_units: account.measurement_units.map {|measurement_unit| {text: measurement_unit.name, value: measurement_unit.id}},
      branch_offices: account.branch_offices.map {|branch_office| {text: branch_office.name, value: branch_office.id}},
      departments: account.departments.map {|department| {text: department.name, value: department.id}},
      brands: account.brands.map {|brand| {text: brand.name, value: brand.id}}
    }
  end

  private

  def can_be_destroyed
    errors.add(:base, "Existen ventas asignadas a este producto.") and throw(:abort) unless account.sales_details.where(product: self).blank?
  end
end
