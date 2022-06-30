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
      bill_templates: @account.bill_templates,
      billing_fields: @account.billing_fields,
      sale_client_id: @account.sale_client_id,
      billing_employee_presence: @account.billing_employee_presence,
      product_price_editable: @account.product_price_editable,
      product_name_editable: @account.product_name_editable,
      inventory_count: @account.inventory_count,
      employees: @account.employees.map {|employee| {text: employee.name, value: employee.id}}
    }
  end
end