class Department < ApplicationRecord
  belongs_to :account,       class_name: "Account", foreign_key: "accounts_id"
  belongs_to :user_creator,  class_name: "User",    foreign_key: "user_creator_id"
  belongs_to :user_modifier, class_name: "User",    foreign_key: "user_modifier_id"

  has_many   :activities, foreign_key: "departments_id"

  validates :name, presence: true

  before_destroy :can_be_destroyed

  include LoggerConcern

  def self.options account
    {
      departments: account.departments.map {|department| {text: department.name, value: department.id}}
    }
  end

  private

  def can_be_destroyed
    errors.add(:base, "Existen productos asignadas a este departamento'") and throw(:abort) unless account.products.where(department: self).blank?
  end
end
