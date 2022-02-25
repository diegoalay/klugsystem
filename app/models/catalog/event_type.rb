class Catalog::EventType < ApplicationRecord
  validates :name, presence: true

  include LoggerConcern
end
