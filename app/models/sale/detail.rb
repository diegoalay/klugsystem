class Sale::Detail < ApplicationRecord
  belongs_to :account,       class_name: "Account", foreign_key: "accounts_id"
  belongs_to :sale,          class_name: "Sale",    foreign_key: "sales_id"
  belongs_to :product,       class_name: "Product", foreign_key: "products_id", optional: true
end
