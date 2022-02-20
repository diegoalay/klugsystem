class ProductFiles < ActiveRecord::Migration[6.1]
  def change
    table_base_structure = JSON.parse(File.read(Rails.root.join("db","structure","files.json")))

    create_table :product_files do |t|
      table_base_structure.each do |column|
        t.send(
          column["type"].parameterize.underscore.to_sym,
          !!column["index"] ?
            "#{column["name"].parameterize.underscore.to_sym}, index: true" :
            column["name"].parameterize.underscore.to_sym
        )
      end

      t.timestamps
    end

    add_reference   :product_files, :product, foreign_key: true

    add_foreign_key :product_files, :users,   column: :user_creator_id
    add_foreign_key :product_files, :users,   column: :user_modifier_id
  end
end
