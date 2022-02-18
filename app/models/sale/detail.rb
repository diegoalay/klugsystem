class Sale::Detail < ApplicationRecord
  belongs_to :account,       class_name: "Account", foreign_key: "account_id"
  belongs_to :sale,          class_name: "Sale",    foreign_key: "sale_id"
  belongs_to :product,       class_name: "Product", foreign_key: "product_id", optional: true
end
