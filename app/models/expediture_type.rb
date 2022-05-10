class ExpeditureType < ApplicationRecord
  validates :name, presence: true

  include LoggerConcern

  acts_as_paranoid
end
