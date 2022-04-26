class CreateSaleElectronicBills < ActiveRecord::Migration[6.1]
  def change
    create_table :sale_electronic_bills do |t|
      t.string :identifier
      t.string :serie
      t.string :number

      t.datetime :certification_datetime
      t.datetime :annulment_datetime

      t.jsonb :data

      # documents
      t.text :billing_base_64_xml
      t.text :billing_base_64_html
      t.text :billing_base_64_pdf

      t.timestamps
    end

    add_reference   :sale_electronic_bills,  :sale,     foreign_key: true
  end
end
