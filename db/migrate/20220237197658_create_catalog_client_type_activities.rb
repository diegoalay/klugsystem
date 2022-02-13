class CreateCatalogClientTypeActivities < ActiveRecord::Migration[6.1]
  def change
    table_base_structure = JSON.parse(File.read(Rails.root.join("db","structure","activities.json")))

    create_table :catalog_client_type_activities do |t|
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

    add_reference   :catalog_client_type_activities, :catalog_client_types, foreign_key: true

    add_foreign_key :catalog_client_type_activities, :users,   column: :user_creator_id
    add_foreign_key :catalog_client_type_activities, :users,   column: :user_modifier_id
  end
end
