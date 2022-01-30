class Product < ApplicationRecord
  acts_as_paranoid

  belongs_to :account,       class_name: "Account", foreign_key: "accounts_id"
  belongs_to :user_creator,  class_name: "User",    foreign_key: "user_creator_id"
  belongs_to :user_modifier, class_name: "User",    foreign_key: "user_modifier_id"

  belongs_to :brand,          class_name: "Brand",        foreign_key: "brands_id",        optional: :true
  belongs_to :department,     class_name: "Department",   foreign_key: "departments_id",   optional: :true
  belongs_to :branch_office,  class_name: "BranchOffice", foreign_key: "branch_offices_id"
  belongs_to :item,           class_name: "Item",         foreign_key: "items_id"

  has_many   :activities, foreign_key: "products_id"

  validates :name, presence: true

  include LoggerConcern

  def self.search account, query
    filters = query[:filters]
    search = filters[:search]&.downcase

    products = account.products.select("
      name,
      retail_price,
      wholesale_price,
      -- measurement_unit,
      brands.name as brand_name,
      departments.name as department_name,
      branch_office.name as branch_office_name,
    ")

    products = products.where("
      lower(sku) like '%#{search}%' or
      lower(name) like '%#{search}%'
    ") if search

    products = products.where("brands_id = ? ", filters[:brands_id]) if filters[:brands_id]
    products = products.where("departments_id = ? ", filters[:department_id]) if filters[:department_id]
    products = products.where("branch_offices_id = ? ", filters[:branch_office_id]) if filters[:branch_office_id]

    products
  end

  def self.options account
    {
      branch_office: account.branch_offices.map {|branch_office| {text: branch_office.name, value: branch_office.id}},
      departments: account.departments.map {|department| {text: department.name, value: department.id}},
      brands: account.brands.map {|brand| {text: brand.name, value: brand.id}}
    }
  end
end
