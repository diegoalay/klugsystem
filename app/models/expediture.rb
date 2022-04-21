class Expediture < ApplicationRecord
  include LoggerConcern

  belongs_to :expediture_type, class_name: "ExpeditureType", foreign_key: "expediture_type_id", optional: true

  belongs_to :cash_register, optional: true
  belongs_to :branch_office
  validates :description, presence: true
end