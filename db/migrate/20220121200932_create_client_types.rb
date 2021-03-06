class CreateClientTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :client_types do |t|
      t.datetime :deleted_at, index: true

      t.string :name

      t.text :note

      t.bigint   :user_creator_id
      t.bigint   :user_modifier_id

      t.timestamps
    end

    add_reference   :client_types, :account, foreign_key: true

    add_foreign_key :client_types, :users, column: :user_creator_id
    add_foreign_key :client_types, :users, column: :user_modifier_id
  end
end
