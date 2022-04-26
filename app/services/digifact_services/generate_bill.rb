module DigifactServices
  module GenerateBill
    def generate_bill
      file = XmlServices::GenerateBill.call(@sale)

      resp = certificate(generate_xml)

      if resp.code 200
        @sale.electronic_bill.update(
          certification_datetime: resp.parsed_response['Fecha_de_certificacion'],
          billing_serie: resp.parsed_response['SERIE'],
          billing_number: resp.parsed_response['NUMERO'],
          identifier: respon.parsed_response['Autorizacion']
        )
      else
        # save error
        # @sale.activities.create(

        # )
      end
    end
  end
end