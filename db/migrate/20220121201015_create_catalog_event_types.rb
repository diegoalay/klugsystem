class CreateCatalogEventTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :catalog_event_types do |t|
      t.datetime :deleted_at, index: true

      t.string :name

      t.text :note

      t.string :model_type, index: true

      t.bigint   :user_creator_id
      t.bigint   :user_modifier_id

      t.timestamps
    end

    add_reference   :catalog_event_types, :accounts, foreign_key: true

    add_foreign_key :catalog_event_types, :users, column: :user_creator_id
    add_foreign_key :catalog_event_types, :users, column: :user_modifier_id
  end
end
