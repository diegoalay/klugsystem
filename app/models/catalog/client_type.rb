class Catalog::ClientType < ApplicationRecord
  belongs_to :account,       class_name: "Account", foreign_key: "accounts_id"
  belongs_to :user_creator,  class_name: "User",    foreign_key: "user_creator_id"
  belongs_to :user_modifier, class_name: "User",    foreign_key: "user_modifier_id"

  has_many   :activities, foreign_key: "catalog_client_types_id"

  validates :name, presence: true

  include LoggerConcern
end
