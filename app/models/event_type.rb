class EventType < ApplicationRecord
  validates :name, presence: true

  include LoggerConcern
end
