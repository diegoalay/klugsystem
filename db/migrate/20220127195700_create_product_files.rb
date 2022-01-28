class CreateProductFiles < ActiveRecord::Migration[6.1]
  def change
    create_table :product_files do |t|

      t.timestamps
    end
  end
end
