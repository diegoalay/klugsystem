class Role < ApplicationRecord
  has_many :user_roles, foreign_key: 'role_id',class_name: 'User::Role'
  has_many :users, through: :user_roles, source: :user
  has_many :menu_items

  include LoggerConcern
end