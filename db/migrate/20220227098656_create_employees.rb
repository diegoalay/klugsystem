class CreateEmployees < ActiveRecord::Migration[6.1]
  def change
    create_table :employees do |t|
      # personal information
      t.string    :first_name
      t.string    :second_name
      t.string    :third_name
      t.string    :surname
      t.string    :second_surname
      t.string    :married_name
      t.date      :birthdate

      t.string    :identity_document_number
      t.string    :passport_number

      t.string    :marital_status
      t.string    :gender
      t.string    :blood_type

      t.json      :biography
      t.json      :family_background
      t.json      :health_details

      t.date      :contract_date
      t.decimal   :salary_base
      t.decimal   :salary_administrative
      t.decimal   :bonuses

      t.bigint :user_creator_id
      t.bigint :user_modifier_id

      t.datetime :deleted_at, index: true

      t.timestamps
    end
    add_reference   :employees, :accounts,     foreign_key: true

    add_foreign_key :employees, :users, column: :user_creator_id
    add_foreign_key :employees, :users, column: :user_modifier_id
  end
end
