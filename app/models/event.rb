class Event < ApplicationRecord
  include LoggerConcern

  belongs_to :model, polymorphic: true, optional: true

  belongs_to :event_type, class_name: "EventType", foreign_key: "event_type_id", optional: true

  acts_as_paranoid
end
