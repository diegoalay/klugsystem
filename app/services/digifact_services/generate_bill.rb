module DigifactServices
  module GenerateBill
    include XmlServices::Helper

    def generate_bill
      file = XmlServices::BillService.new(@sale).call

      resp = certificate(file)

      debugger

      if resp.code.eql? 200
        @sale.electronic_bill.update(
          certification_datetime: timefy(resp.parsed_response['Fecha_de_certificacion']),
          serie: resp.parsed_response['SERIE'],
          number: resp.parsed_response['NUMERO'],
          identifier: resp.parsed_response['Autorizacion'],
          data: resp.parsed_response
        )
      else
        # save error
        @sale.activities.create(
          description: resp.parsed_response['ResponseDATA1'],
          category: 'electronic_bill_failed',
          user_creator: @sale.user_creator
        )
      end
    end
  end
end