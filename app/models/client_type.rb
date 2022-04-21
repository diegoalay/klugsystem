class ClientType < Shared::Activity
  validates :name, presence: true

  include LoggerConcern
end
