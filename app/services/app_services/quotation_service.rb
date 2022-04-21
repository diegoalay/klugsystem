module AppServices
  class QuotationService
    def initialize(quotation, quotation_products, current_user)
      @quotation = quotation
      @quotation_products = quotation_products
      @current_user = current_user
    end

    def call
      ActiveRecord::Base.transaction do
        @quotation_products.each do |quotation_product|
          quotation_detail = @quotation.details.new(
            account: @current_user.account,
            product_id: quotation_product["id"],
            name: quotation_product["name"],
            price: quotation_product["price"],
            total: quotation_product["total"],
            quantity: quotation_product["quantity"],
            subtotal: quotation_product["subtotal"],
            discount_value: quotation_product["discount_value"],
            discount_percentage: quotation_product["discount_percentage"]
          )

          if (quotation_detail.save!)
            product = @current_user.account.products.find_by(id: quotation_product["id"])

            if (product)
              ActiveRecord::Base.transaction do
                transaction = product.transactions.new(
                  category: "decrease",
                  user_creator: @current_user,
                  transaction_type: @current_user.account.product_transaction_quotation_type,
                  quantity: quotation_product["quantity"],
                  model_id: @quotation.id,
                  model_type: "Quotation",
                )

                transaction.save!
              end
            end
          end
        end
      end
    end
  end
end