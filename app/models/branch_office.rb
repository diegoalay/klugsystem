class BranchOffice < ApplicationRecord
  belongs_to :account,       class_name: "Account", foreign_key: "accounts_id"
  belongs_to :user_creator,  class_name: "User",    foreign_key: "user_creator_id"
  belongs_to :user_modifier, class_name: "User",    foreign_key: "user_modifier_id"

  has_many   :activities, foreign_key: "branch_offices_id"

  validates :name,       presence: true
  validates :telephone,  presence: true

  before_destroy :can_be_destroyed

  include LoggerConcern

  private

  def can_be_destroyed
    errors.add(:base, "Existen ventas asignadas a esta sucursal'") and throw(:abort) unless account.sales.where(branch_office: self).blank?
    errors.add(:base, "Existen productos asignadas a esta sucursal'") and throw(:abort) unless account.products.where(branch_office: self).blank?
  end
end
