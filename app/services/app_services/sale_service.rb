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
            quantity: sale_product["saleQuantity"],
            subtotal: sale_product["subtotal"],
            discount_value: sale_product["discount_value"],
            discount_percentage: sale_product["discount_percentage"],
            interest_value: sale_product["interest_value"],
            interest_percentage: sale_product["interest_percentage"],
            measurement_unit: sale_product["measurement_unit"],
            product_type: sale_product["product_type"]
          )

          sale_detail.save!
        end
      end
    end
  end
end