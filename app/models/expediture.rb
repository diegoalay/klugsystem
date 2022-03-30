class Expediture < ApplicationRecord
  belongs_to :expediture_type, class_name: "Catalog::ExpeditureType", foreign_key: "catalog_expediture_type_id", optional: true

  belongs_to :cash_register, optional: true

  include LoggerConcern

  validates :description, presence: true
end