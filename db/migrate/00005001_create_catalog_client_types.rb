class CreateCatalogClientTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :catalog_client_types do |t|
      t.datetime :deleted_at, index: true

      t.string :name

      t.bigint   :user_creator_id

      t.timestamps
    end

    add_reference   :catalog_client_types, :accounts, foreign_key: true

    add_foreign_key :catalog_client_types, :users, column: :user_creator_id
  end
end
