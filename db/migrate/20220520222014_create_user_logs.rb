class CreateUserLogs < ActiveRecord::Migration[6.1]
  def change
    create_table :user_logs do |t|
      t.string :description
      t.string :category
      t.string :title

      t.timestamps
    end

    add_reference :user_logs, :user, foreign_key: true
  end
end
