class CreateExpeditureTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :expediture_types do |t|
      t.string :name

      t.text :note

      t.datetime :deleted_at, index: true

      t.bigint   :user_creator_id
      t.bigint   :user_modifier_id

      t.timestamps
    end

    add_reference   :expediture_types, :account, foreign_key: true

    add_foreign_key :expediture_types, :users, column: :user_creator_id
    add_foreign_key :expediture_types, :users, column: :user_modifier_id
  end
end
