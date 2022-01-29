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
end
