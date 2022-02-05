class Sale < ApplicationRecord
  acts_as_paranoid

  belongs_to :account,       class_name: "Account", foreign_key: "accounts_id"
  belongs_to :user_creator,  class_name: "User",    foreign_key: "user_creator_id"
  belongs_to :user_modifier, class_name: "User",    foreign_key: "user_modifier_id"

  has_many   :activities, foreign_key: "clients_id"

  validates :first_name, presence: true
  validates :last_name,  presence: true

  include LoggerConcern

  enum sale_type: {
    sale: 'sale',
    bill: 'bill',
    electronic_bill: 'electronic_bill',
    receipt: 'receipt'
  }

  def self.options account
    {
      payment_methods: account.payment_methods.where(status: true).map {|payment_method| {text: payment_method.name, value: payment_method}},
      branch_office: account.branch_offices.map {|branch_office| {text: branch_office.name, value: branch_office.id}},
      departments: account.departments.map {|department| {text: department.name, value: department.id}},
      brands: account.brands.map {|brand| {text: brand.name, value: brand.id}},
      sale_types: sale_types.map {|k, v| {text: k, value: v}}
    }
  end
end