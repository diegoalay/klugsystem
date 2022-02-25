class Catalog::ExpeditureType < ApplicationRecord
  validates :name, presence: true

  include LoggerConcern
end
