class CreateRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :roles do |t|
      t.string    :name
      t.string    :code
      t.boolean   :active
      t.string    :default_path

      t.datetime :deleted_at, index: true

      t.timestamps
    end

    add_reference   :roles, :account, foreign_key: true
  end
end
