class CreateItem < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :name
      t.text   :description

      t.bigint :user_creator_id
      t.bigint :user_modifier_id

      t.timestamps
    end

    add_reference   :items, :accounts,     foreign_key: true
    add_foreign_key :items, :users, column: :user_creator_id
    add_foreign_key :items, :users, column: :user_modifier_id
  end
end
