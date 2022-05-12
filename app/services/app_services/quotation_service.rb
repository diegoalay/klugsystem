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
            quantity: quotation_product["saleQuantity"],
            subtotal: quotation_product["subtotal"],
            discount_value: quotation_product["discount_value"],
            discount_percentage: quotation_product["discount_percentage"],
            interest_value: quotation_product["interest_value"],
            interest_percentage: quotation_product["interest_percentage"],
            product_type: quotation_product["product_type"],
            final_subtotal: quotation_product["final_subtotal"]
          )

          quotation_detail.save!
        end
      end
    end
  end
end