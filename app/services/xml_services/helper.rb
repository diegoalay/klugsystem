module XmlServices
  module Helper
    def client_billing_municipality
      municipality = @sale.client.billing_municipality
      municipality = @sale.branch_office.billing_municipality if municipality.blank?

      municipality
    end

    def client_billing_department
      department = @sale.client.billing_department
      department = @sale.branch_office.billing_department if department.blank?

      department
    end

    def client_billing_postcode
      postcode = @sale.client.billing_postcode
      postcode = @sale.branch_office.billing_postcode if postcode.blank?

      postcode
    end

    def timefy datetime
      (DateTime.iso8601 datetime) + 6.hours
    end

    def date_format(date)
      date.strftime("%Y-%m-%dT%H:%M:%S")
    end

    def item_tax_amount(item)
      item_taxable_amount(item) * 0.12
    end

    def item_taxable_amount(item)
      (item.subtotal - item.discount_value) / 1.12
    end

    def item_product_type(item)
      return "B" if item.product_type == "good"
      return "S"
    end

    def item_measurement_unit(item)
      item.measurement_unit.upcase.split(" ").map do |word| word.first end.join
    end

    def round(val, decimals = 2)
      val.round(decimals)
    end
  end
end
