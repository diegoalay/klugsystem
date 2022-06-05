class Finance::BillQuery < SaleQuery
  def options(current_user)
    {
      product_types: Product.product_types.map { |k,_v|
        {
          text: I18n.t("models.products.column_enum_product_type_#{k}").split('')[0],
          value: k
        }
      },
      payment_methods: @account.payment_methods.where(status: true)
                      .map {|payment_method| { text: payment_method.name, value: payment_method }},
      measurement_units: @account.measurement_units
                        .map {|measurement_unit| {text: measurement_unit.name, value: measurement_unit.name}},
      sale_types: ::Sale.fetch_sale_types(current_user),
      bill_templates: @account.bill_templates
    }
  end
end