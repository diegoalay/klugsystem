module DigifactServices
  module AnulateBill
    include XmlServices::Helper

    def anulate_bill
      file = XmlServices::BillAnnulmentService.new(@sale).call

      resp = annulment(file)

      if resp.code.eql? 200
        @sale.electronic_bill.update(
          annulment_datetime: timefy(resp.parsed_response['Fecha_de_certificacion']),
          annulment_data: resp.parsed_response
        )
      else
        @sale.electronic_bill.update(
          annulment_data: resp.parsed_response
        )

        # save error
        @sale.activities.create(
          description: resp.parsed_response['ResponseDATA1'],
          category: 'electronic_annulment_failed',
          user_creator: @sale.user_creator
        )
      end
    end
  end
end