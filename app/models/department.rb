class Department < ApplicationRecord
  include LoggerConcern

  validates :name, presence: true

  before_destroy :can_be_destroyed

  acts_as_paranoid

  def self.options account
    {
      departments: account.departments.map {|department| {text: department.name, value: department.id}}
    }
  end

  private

  def can_be_destroyed
    errors.add(:base, "Existen productos asignados a este departamento.") and throw(:abort) unless account.products.where(department: self).blank?
  end
end
