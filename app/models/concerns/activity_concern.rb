
  module ActivityConcern
    extend ActiveSupport::Concern

    included do
        belongs_to :user_creator, class_name: "::User", foreign_key: "user_creator_id", optional: true
    end
end