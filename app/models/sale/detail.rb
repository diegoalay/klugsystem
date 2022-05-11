class Sale::Detail < ApplicationRecord
  belongs_to :account
  belongs_to :sale
  belongs_to :product, optional: true

  attribute :status, :boolean, default: true
end
