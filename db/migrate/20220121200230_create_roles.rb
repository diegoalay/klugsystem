class CreateRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :roles do |t|
      t.string    :name
      t.string    :code
      t.boolean   :active
      t.string    :default_path

      # Users Relations
      t.bigint :user_creator_id
      t.bigint :user_modifier_id

      t.datetime :deleted_at, index: true

      t.timestamps
    end

    add_reference   :roles, :account, foreign_key: true
  end
end
