class Shared::Activity < ApplicationRecord
  self.abstract_class = true

  belongs_to :user_creator,  class_name: "User",    foreign_key: "user_creator_id"
end