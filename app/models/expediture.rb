class Expediture < ApplicationRecord
    include LoggerConcern

    validates :description, presence: true
end
