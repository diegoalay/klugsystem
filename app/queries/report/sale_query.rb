class Report::SaleQuery < SaleQuery
  def show(current_user, query)
    sales = Report::SaleQuery.new(@account).index(current_user, query)

    if (query[:pagination][:disable])
      valid_sales = sales.where(status: true)
      invalid_sales = sales.where(status: false)

      return {
        total: sales.length,
        valid_sales_count: valid_sales.length,
        valid_sales: valid_sales.sum(:total),
        invalid_sales_count: invalid_sales.length,
        invalid_sales: invalid_sales.sum(:total),
        discounts: valid_sales.sum(:discount),
        discounts_count: valid_sales.where("discount != ? or discount != ?", nil, 0).length,
        interests: valid_sales.sum(:interest),
        interests_count: valid_sales.where("interest != ? or interest != ?", nil, 0).length
      }
    end

    sales
  end
end