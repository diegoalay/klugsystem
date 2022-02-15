class CreateBrands < ActiveRecord::Migration[6.1]
  def change
    create_table :brands do |t|
      t.string :name

      t.datetime :deleted_at, index: true

      t.bigint :user_creator_id
      t.bigint :user_modifier_id

      t.timestamps
    end

    add_reference   :brands, :account,     foreign_key: true
    add_foreign_key :brands, :users, column: :user_creator_id
    add_foreign_key :brands, :users, column: :user_modifier_id
  end
end
