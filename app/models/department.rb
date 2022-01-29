class Department < ApplicationRecord
  acts_as_paranoid

  belongs_to :account,       class_name: "Account", foreign_key: "accounts_id"
  belongs_to :user_creator,  class_name: "User",    foreign_key: "user_creator_id"
  belongs_to :user_modifier, class_name: "User",    foreign_key: "user_modifier_id"

  has_many   :activities, foreign_key: "departments_id"

  validates :name, presence: true

  include LoggerConcern

  def self.options account
    {
      departments: account.departments.map {|department| {text: department.name, value: department.id}}
    }
  end
end
