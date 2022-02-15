class CreateUserRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :user_roles do |t|
      t.datetime :deleted_at, index: true

      t.bigint   :user_creator_id
      t.bigint   :user_modifier_id

      t.timestamps
    end

    add_reference :user_roles, :user, foreign_key: true
    add_reference :user_roles, :role, foreign_key: true

    add_foreign_key :user_roles, :users, column: :user_creator_id
    add_foreign_key :user_roles, :users, column: :user_modifier_id
  end
end