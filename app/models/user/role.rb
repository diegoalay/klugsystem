class User::Role < ApplicationRecord
  belongs_to :user
  belongs_to :roles, foreign_key: "role_id", class_name: "::Role"
end
