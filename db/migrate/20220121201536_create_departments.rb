class CreateDepartments < ActiveRecord::Migration[6.1]
  def change
    create_table :departments do |t|
      t.string :name

      t.datetime :deleted_at, index: true

      t.bigint :user_creator_id
      t.bigint :user_modifier_id

      t.timestamps
    end

    add_reference   :departments, :departments,   foreign_key: true
    add_reference   :departments, :accounts,      foreign_key: true
    add_foreign_key :departments, :users, column: :user_creator_id
    add_foreign_key :departments, :users, column: :user_modifier_id
  end
end
