class Account::BillingField < ApplicationRecord
  include LoggerConcern

  validates :title, presence: true
  validates :color, presence: true
  validates :position_x, presence: true
  validates :position_y, presence: true
end
