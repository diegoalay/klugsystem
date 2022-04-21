class CreateRoleMenuItems < ActiveRecord::Migration[6.1]
  def change
    create_table :role_menu_items do |t|
      t.boolean :status, default: true
      t.bigint :user_creator_id
      t.bigint :user_modifier_id

      t.timestamps
    end

    add_reference   :role_menu_items, :role, foreign_key: true
    add_reference   :role_menu_items, :menu_item, foreign_key: true

    add_foreign_key :role_menu_items, :users, column: :user_creator_id
    add_foreign_key :role_menu_items, :users, column: :user_modifier_id
  end
end
