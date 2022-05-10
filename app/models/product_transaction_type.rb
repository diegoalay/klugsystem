class ProductTransactionType < ApplicationRecord
  include LoggerConcern

  before_create :generate_code
  before_destroy   :can_be_destroyed

  acts_as_paranoid

  private

  def can_be_destroyed
    errors.add(:base, "Este tipo de transacción no puede ser eliminado.") and throw(:abort) if code == "product-sale"
    errors.add(:base, "Existen transacciones asignadas a este tipo.") and throw(:abort) unless Product::Transaction.where(transaction_type: self).blank?
  end

  def generate_code
    unless (name.blank?)
      custom_code = name
      .downcase                           # string to lowercase
      .gsub(/[^0-9A-Za-z\s\-\_]/, '')     # remove special characters from string
      .gsub(/-/, '_')                     # replace dashes with underscore
      .gsub(/\s+/, '_')                   # replace spaces or spaces with single dash
      .gsub("-", "_")                     # replace - (->) _

      self.code ||= custom_code
    end
  end
end