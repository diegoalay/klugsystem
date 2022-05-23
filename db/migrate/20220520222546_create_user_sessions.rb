class CreateUserSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :user_sessions do |t|

      t.inet     :user_remote
      t.string   :user_agent
      t.datetime :last_used_at
      t.boolean  :active, default: true

      t.timestamps
    end

    add_reference :user_sessions, :user, foreign_key: true
  end
end
