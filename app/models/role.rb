class Role < ApplicationRecord
  has_many :user_roles, foreign_key: 'role_id',class_name: 'User::Role'
  has_many :users, through: :user_roles, source: :user
  has_many :menu_items

  include LoggerConcern

  def admin?
    name.downcase === "admin"
  end

  def send_menu_items_ws
    # ::MenuItem.select('id', 'key', 'permissions') if admin?

    # items = self.reload.menu_items.joins(:menu_item).where("status = ?", true)
    # items = items.select('menu_items.id', 'menu_items.key', 'menu_items.permissions')

    # RolesChannel.broadcast_to(self, {
    #   data: items
    # })
  end
end