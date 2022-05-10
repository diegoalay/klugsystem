class MeasurementUnit < ApplicationRecord
  include LoggerConcern

  has_many :products

  before_destroy :can_be_destroyed

  acts_as_paranoid

  def can_be_destroyed
    errors.add(:base, "Existen productos asignados a esta unidad de medida") and throw(:abort) unless products.where(measurement_unit: self).blank?
  end
end
