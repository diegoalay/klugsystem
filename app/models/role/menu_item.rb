class Role::MenuItem < ApplicationRecord
  include LoggerConcern

  belongs_to :menu_item, class_name: '::MenuItem'
  belongs_to :role, class_name: '::Role'

  after_update  :send_roles_ws
  after_create  :send_roles_ws
  after_destroy :send_roles_ws

  private

  def send_roles_ws
    role.send_menu_items_ws
  end
end
