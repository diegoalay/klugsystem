class Product < ApplicationRecord
  include LoggerConcern

  belongs_to :brand,          class_name: "Brand",        foreign_key: "brand_id",        optional: :true
  belongs_to :department,     class_name: "Department",   foreign_key: "department_id",   optional: :true
  belongs_to :branch_office,  class_name: "BranchOffice", foreign_key: "branch_office_id"

  has_many :sale_details,  class_name: "Sale::Detail", foreign_key: "product_id"

  has_many :files

  validates :sku, presence: true
  validates :name, presence: true
  validates :quantity, presence: true
  validates :retail_price, presence: true

  before_destroy :can_be_destroyed

  def self.index account, query
    search = query[:filters][:search]&.downcase

    products = account.products.select("
      products.id,
      products.sku,
      products.name,
      products.retail_price,
      products.wholesale_price,
      products.quantity,
      products.product_file_id,
      case
        when products.quantity <= 0 then 'Agotado'
        else 'Disponible'
      end as status
    ")
    .joins(:branch_office)
    .left_joins(:brand, :department)

    products = products.where("
      lower(products.status) like '%#{search}%' or
      lower(products.sku) like '%#{search}%' or
      lower(products.name) like '%#{search}%' or
      cast(products.retail_price as varchar) like '%#{search}%' or
      cast(products.wholesale_price as varchar) like '%#{search}%' or
      cast(products.quantity as varchar) like '%#{search}%'
    ") unless search.blank?

    if (!!query[:filters][:top_products])
      # most seller products in the last 30 days
      return products
      .group(
        "products.id",
        "products.sku",
        "products.name",
        "products.retail_price",
        "products.wholesale_price",
        "products.quantity",
        "products.product_file_id"
      )
      .select("count(*) as sales")
      .joins("
        left join sale_details
          on sale_details.product_id = products.id
        left join sales
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
      products: products
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
      concat(
        products.name,
        ' [',
        products.sku,
        ']'
      ) as details,
      products.product_file_id
    ")
    .left_joins(:brand, :department, :branch_office)

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
    statistics = self.account.sales_details.joins(:sale).where(product: self)
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
    self.attributes.merge({
      details: name.to_s + " [" + sku.to_s + "]",
      statistics: self.sale_statistics
    })
  end

  def self.options account
    {
      branch_offices: account.branch_offices.map {|branch_office| {text: branch_office.name, value: branch_office.id}},
      departments: account.departments.map {|department| {text: department.name, value: department.id}},
      brands: account.brands.map {|brand| {text: brand.name, value: brand.id}}
    }
  end

  private

  def can_be_destroyed
    errors.add(:base, "Existen ventas asignadas a este producto'") and throw(:abort) unless account.sales_details.where(product: self).blank?
  end
end
