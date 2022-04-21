module AppServices
  class SaleService
    def initialize(sale, sale_products, current_user)
      @sale = sale
      @sale_products = sale_products
      @current_user = current_user
    end

    def call
      ActiveRecord::Base.transaction do
        @sale_products.each do |sale_product|
          sale_detail = @sale.details.new(
            account: @current_user.account,
            product_id: sale_product["id"],
            name: sale_product["name"],
            price: sale_product["price"],
            total: sale_product["total"],
            quantity: sale_product["quantity"],
            subtotal: sale_product["subtotal"],
            discount_value: sale_product["discount_value"],
            discount_percentage: sale_product["discount_percentage"]
          )

          if (sale_detail.save!)
            product = @current_user.account.products.find_by(id: sale_product["id"])

            if (product)
              ActiveRecord::Base.transaction do
                transaction = product.transactions.new(
                  category: "decrease",
                  user_creator: @current_user,
                  transaction_type: @current_user.account.product_transaction_sale_type,
                  quantity: sale_product["quantity"],
                  model_id: @sale.id,
                  model_type: "Sale",
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