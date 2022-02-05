class Product < ApplicationRecord
  acts_as_paranoid

  belongs_to :account,       class_name: "Account", foreign_key: "accounts_id"
  belongs_to :user_creator,  class_name: "User",    foreign_key: "user_creator_id"
  belongs_to :user_modifier, class_name: "User",    foreign_key: "user_modifier_id"

  belongs_to :brand,          class_name: "Brand",        foreign_key: "brands_id",        optional: :true
  belongs_to :department,     class_name: "Department",   foreign_key: "departments_id",   optional: :true
  belongs_to :branch_office,  class_name: "BranchOffice", foreign_key: "branch_offices_id"

  has_many   :activities, foreign_key: "products_id"

  validates :sku, presence: true
  validates :name, presence: true
  validates :quantity, presence: true
  validates :retail_price, presence: true

  include LoggerConcern

  def self.index account, query
    search = query[:filters][:search]

    products = account.products.select("
      products.id,
      products.sku,
      products.name,
      products.retail_price,
      products.wholesale_price,
      products.quantity
    ")
    .joins(:branch_office)
    .left_joins(:brand, :department)

    products = products.where("
      lower(products.sku) like '%#{search}%' or
      lower(products.name) like '%#{search}%' or
      cast(products.retail_price as varchar) like '%#{search}%' or
      cast(products.wholesale_price as varchar) like '%#{search}%' or
      cast(products.quantity as varchar) like '%#{search}%'
    ") unless search.blank?

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
      quantity,
      brands.name as brand_name,
      departments.name as department_name,
      branch_offices.name as branch_office_name,
      concat(
        products.name,
        ' [',
        products.sku,
        ']'
      ) as details
    ")
    .left_joins(:brand, :department, :branch_office)

    products = products.where("
      lower(products.sku) like '%#{search}%' or
      lower(products.name) like '%#{search}%'
    ") if search

    products = products.where("brands_id = ? ", filters[:brands_id]) if filters[:brands_id]
    products = products.where("departments_id = ? ", filters[:department_id]) if filters[:department_id]
    products = products.where("branch_offices_id = ? ", filters[:branch_office_id]) if filters[:branch_office_id]

    products
  end

  # def self.create_products
  #   account = Account.first
  #   user = User.first
  #   branch_office = BranchOffice.first

  #   (0..2000).each do |n|
  #     account.products.create!(
  #       sku: Faker::Number.number(digits: 10).to_s,
  #       name: Faker::Food.dish,
  #       retail_price: rand(100),
  #       quantity: rand(30),
  #       user_creator: user,
  #       user_modifier: user,
  #       branch_office: branch_office
  #     )
  #   end
  # end

  def self.options account
    {
      branch_offices: account.branch_offices.map {|branch_office| {text: branch_office.name, value: branch_office.id}},
      departments: account.departments.map {|department| {text: department.name, value: department.id}},
      brands: account.brands.map {|brand| {text: brand.name, value: brand.id}}
    }
  end
end
