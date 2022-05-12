module DigifactServices
  class Api
    include DigifactServices::GenerateBill
    include DigifactServices::AnulateBill
    include DigifactServices::Helper

    def initialize(current_user, sale)
      @current_user = current_user
      @token = current_user.account.digifact_token
      @sale = sale
    end

    def headers
      {
        "authorization"=>"#{@token}",
        'Content-Type' => 'application/json'
      }
    end

    def post(url, query = {}, body = {})
      HTTParty.post(
        api_url()  + url,
        headers: headers,
        query: query,
        body: body,
        debug_output: $stdout
      )
    end

    def get(url, query = {}, body = {})
      HTTParty.get(
        api_download_url() + url,
        headers: headers,
        query: query,
        body: body,
        debug_output: $stdout
      )
    end

    def download()
      unless test_mode?
        get('', generate_params('GET_DOCUMENT').merge('GUID' => @sale.electronic_bill.identifier))
      else
        @sale.electronic_bill.certification_data
      end
    end

    def certificate(body)
      post('', generate_params('CERTIFICATE_DTE_XML_TOSIGN'), body)
    end

    def annulment(body)
      post('', generate_params('ANULAR_FEL_TOSIGN'), body)
    end

    def generate_params(type)
      {
        USERNAME: @current_user.account.digifact_user,
        NIT: @current_user.account.digifact_billing_identifier,
        FORMAT: 'XML,HTML,PDF',
        TIPO: type
      }
    end

    def timeify(timestamp)
      DateTime.iso8601 timestamp if timestamp
    end
  end
end