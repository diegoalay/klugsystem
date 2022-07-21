class Product::Transaction < ApplicationRecord
  belongs_to :product, class_name: "Product", foreign_key: "product_id"

  belongs_to :transaction_type, class_name: "ProductTransactionType", foreign_key: "product_transaction_type_id", optional: true
  belongs_to :user_creator,     class_name: "User",    foreign_key: "user_creator_id"
  belongs_to :model,            polymorphic: true, optional: true

  validate :validate_quantity
  after_create :set_product_quantity

  enum category: {
    increase: "increase",
    decrease: "decrease"
  }

  def self.options(account)
    {
      transaction_types: account.product_transaction_types
      .where.not("code = ?", "product-sale")
      .order(:name)
      .map {
        |product_transaction_type|
          {
            text: product_transaction_type.name,
            value: product_transaction_type.id
          }
      }
    }
  end

  def self.index account, product, query
    transactions = product.transactions
    .joins(:user_creator)
    .joins(:transaction_type)
    .select(
      "concat(users.first_name, ' ', users.first_surname) as user_creator_name",
      "product_transaction_types.name as transaction_type",
      "product_transactions.quantity",
      "product_transactions.category",
      "product_transactions.created_at",
      "product_transactions.model_type",
      "product_transactions.model_id",
      "product_transactions.description"
    )

    transactions = transactions.page(query[:pagination][:current_page])
    .per(query[:pagination][:per_page])
    .order("#{query[:pagination][:order_by]} #{query[:pagination][:order]} nulls last")

    {
      current_page: transactions.current_page,
      total_pages: transactions.total_pages,
      total_count: transactions.total_count,
      total_lenght: transactions.length,
      transactions: transactions.map do |transaction|
        transaction.attributes.merge({
          model_details: transaction.model
        })
      end
    }
  end

  def validate_quantity
    if product.account.inventory_count
      if quantity > product.quantity && category == "decrease"
        errors.add(:base, "El egreso debe ser menor o igual a la cantidad actual de las existencias")
      end
    end
  end

  private

  def set_product_quantity
    value = quantity * (category == "decrease" ? -1 : 1)

    if !product.account.inventory_count && (self.product.quantity.to_f + value.to_f  < 0)
      quantity = 0
    else
      quantity = (self.product.quantity.to_f + value.to_f)
    end

    self.product.quantity = quantity
    self.product.save(validation: false)
  end
end
