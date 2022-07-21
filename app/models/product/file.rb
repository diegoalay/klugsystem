class Product::File < Shared::File
  belongs_to :object_model, class_name: 'Product', foreign_key: 'product_id'

  def self.allowed_file_extensions
    return [
      'jpeg',
      'png',
      'jpg',
      'gif',
      'webp',
      'heif'
    ]
  end
end
