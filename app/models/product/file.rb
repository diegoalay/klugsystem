class Product::File < Shared::File
  belongs_to :object_model, class_name: "Product", foreign_key: "product_id"
end
