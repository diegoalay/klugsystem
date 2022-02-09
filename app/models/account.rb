class Account < ApplicationRecord
  has_many :payment_methods, class_name: "PaymentMethod", foreign_key: "accounts_id"
  has_many :branch_offices,  class_name: "BranchOffice",  foreign_key: "accounts_id"
  has_many :departments,     class_name: "Department",    foreign_key: "accounts_id"
  has_many :employees,       class_name: "Employee",      foreign_key: "accounts_id"
  has_many :products,        class_name: "Product",       foreign_key: "accounts_id"
  has_many :clients,         class_name: "Client",        foreign_key: "accounts_id"
  has_many :brands,          class_name: "Brand",         foreign_key: "accounts_id"
  has_many :users,           class_name: "User",          foreign_key: "accounts_id"
  has_many :sales,           class_name: "Sale",          foreign_key: "accounts_id"
  has_many :sales_details,   class_name: "Sale::Detail",  foreign_key: "accounts_id"


  # Catalogs
  has_many :client_types, class_name: "Catalog::ClientType", foreign_key: "accounts_id"
  has_many :event_types,  class_name: "Catalog::EventType",  foreign_key: "accounts_id"
end