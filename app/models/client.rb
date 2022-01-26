class Client < ApplicationRecord
  belongs_to :account, class_name: "Account", foreign_key: "accounts_id"

  include LoggerConcern
end