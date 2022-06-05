class BillTemplate < ApplicationRecord
  include LoggerConcern

  validates :name, presence: true

  def self.options(current_user)
    {
      product_types: Product.product_types.map { |k,_v|
        {
          text: I18n.t("models.products.column_enum_product_type_#{k}").split('')[0],
          value: k
        }
      },
      measurement_units: current_user.account.measurement_units
                        .map {|measurement_unit| {text: measurement_unit.name, value: measurement_unit.name}}
    }
  end
end
