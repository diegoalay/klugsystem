class Brand < ApplicationRecord
  belongs_to :account,       class_name: "Account", foreign_key: "accounts_id"
  belongs_to :user_creator,  class_name: "User",    foreign_key: "user_creator_id"
  belongs_to :user_modifier, class_name: "User",    foreign_key: "user_modifier_id"

  has_many   :activities, foreign_key: "brands_id"

  validates :name, presence: true

  before_destroy :can_be_destroyed

  include LoggerConcern

  private

  def can_be_destroyed
    errors.add(:base, "Existen productos asignadas a esta marca'") and throw(:abort) unless account.products.where(brand: self).blank?
  end
end
