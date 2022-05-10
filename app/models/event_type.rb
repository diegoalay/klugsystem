class EventType < ApplicationRecord
  validates :name, presence: true

  include LoggerConcern

  acts_as_paranoid

  before_destroy :can_be_destroyed

  def can_be_destroyed
    errors.add(:base, "Existen eventos asignados a este tipo de evento.") and throw(:abort) unless account.events.where(event_type: self).blank?
  end
end
