class CreateRoleMenuItemActivities < ActiveRecord::Migration[6.1]
  def change
    table_base_structure = JSON.parse(File.read(Rails.root.join("db","structure","activities.json")))

    create_table :role_menu_item_activities do |t|
      table_base_structure.each do |column|
        t.send(
          column["type"].parameterize.underscore.to_sym,
          !!column["index"] ?
            "#{column["name"].parameterize.underscore.to_sym}, index: true" :
            column["name"].parameterize.underscore.to_sym
        )
      end

      t.timestamps
    end

    add_reference   :role_menu_item_activities, :role_menu_item, foreign_key: true

    add_foreign_key :role_menu_item_activities, :users, column: :user_creator_id
    add_foreign_key :role_menu_item_activities, :users, column: :user_modifier_id
  end
end
