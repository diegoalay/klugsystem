class Client::Activity < ApplicationRecord
    belongs_to :user_creator,  class_name: "User",    foreign_key: "user_creator_id"
end
