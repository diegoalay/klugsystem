class Event < ApplicationRecord
  include LoggerConcern

  belongs_to :model, polymorphic: true, optional: true
end
