class Brand < ApplicationRecord
  include LoggerConcern

  validates :name, presence: true

  before_destroy :can_be_destroyed

  private

  def can_be_destroyed
    errors.add(:base, "Existen productos asignados a esta marca.") and throw(:abort) unless account.products.where(brand: self).blank?
  end
end
