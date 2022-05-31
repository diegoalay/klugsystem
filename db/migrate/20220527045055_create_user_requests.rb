class CreateUserRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :user_requests do |t|
      t.string :user_agent
      t.string :controller
      t.string :method
      t.string :action
      t.string :url
      t.string :format
      t.jsonb  :params

      t.timestamps
    end

    add_reference :user_requests, :user, foreign_key: true
  end
end
