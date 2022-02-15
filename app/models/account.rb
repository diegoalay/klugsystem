class Account < ApplicationRecord
  has_many :payment_methods, class_name: "PaymentMethod", foreign_key: "account_id"
  has_many :branch_offices,  class_name: "BranchOffice",  foreign_key: "account_id"
  has_many :departments,     class_name: "Department",    foreign_key: "account_id"
  has_many :employees,       class_name: "Employee",      foreign_key: "account_id"
  has_many :products,        class_name: "Product",       foreign_key: "account_id"
  has_many :clients,         class_name: "Client",        foreign_key: "account_id"
  has_many :brands,          class_name: "Brand",         foreign_key: "account_id"
  has_many :users,           class_name: "User",          foreign_key: "account_id"
  has_many :sales,           class_name: "Sale",          foreign_key: "account_id"
  has_many :sales_details,   class_name: "Sale::Detail",  foreign_key: "account_id"


  # Catalogs
  has_many :catalog_client_types,      class_name: "Catalog::ClientType",      foreign_key: "account_id"
  has_many :catalog_event_types,       class_name: "Catalog::EventType",       foreign_key: "account_id"
  has_many :catalog_expediture_types,  class_name: "Catalog::ExpeditureType",  foreign_key: "account_id"
end