class Quotation::Detail < ApplicationRecord
  belongs_to :account
  belongs_to :quotation
  belongs_to :product, optional: true

  attribute :status, :boolean, default: true
end
