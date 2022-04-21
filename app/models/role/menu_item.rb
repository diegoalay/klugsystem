class Role::MenuItem < ApplicationRecord
  include LoggerConcern

  belongs_to :menu_item, class_name: '::MenuItem'
end
