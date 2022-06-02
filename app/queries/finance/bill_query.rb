class Finance::BillQuery < SaleQuery
  def options
    {
      product_types: Product.product_types.map { |k,_v|
        {
          text: I18n.t("models.products.column_enum_product_type_#{k}").split('')[0],
          value: k
        }
      },
      payment_methods: @account.payment_methods.where(status: true)
                      .map {|payment_method| { text: payment_method.name, value: payment_method }}
    }
  end
end