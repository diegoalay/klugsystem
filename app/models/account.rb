class Account < ApplicationRecord
  has_many :clients, class_name: "Client", foreign_key: "accounts_id"
  has_many :brands,  class_name: "Brand",  foreign_key: "accounts_id"
  has_many :users,   class_name: "User",   foreign_key: "accounts_id"

  # Catalogs
  has_many :client_types, class_name: "Catalog::ClientType", foreign_key: "accounts_id"
  has_many :event_types,  class_name: "Catalog::EventType",  foreign_key: "accounts_id"
end