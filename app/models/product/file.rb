class Product::File < Shared::File
  belongs_to :object_model, class_name: 'Product', foreign_key: 'product_id'

  before_validation :normalize_file_extension, on: :create

  def self.allowed_file_extensions
    return [
      'jpeg',
      'png',
      'jpg',
      'gif',
      'webp',
      'heic'
    ]
  end

  private

  def normalize_file_extension
    self.file_extension = file_extension.downcase
  end
end
