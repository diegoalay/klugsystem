module DigifactServices
  class Api
    include DigifactServices::GenerateBill
    include DigifactServices::AnulateBill

    def initialize(current_user, sale)
      @current_user = current_user
      @token = current_user.account.digifact_token
      @sale = sale

      @api_url2 = 'https://felgtaws.digifact.com.gt/gt.com.fel.api.v3/api/FelRequest'

      if @current_user.account.id === 1 || Rails.env == 'development'
        @api_url   = 'https://felgttestaws.digifact.com.gt/gt.com.fel.api.v3/api/FELRequestV2'
      else
        @api_url   = 'https://felgtaws.digifact.com.gt/gt.com.fel.api.v3/api/FelRequestV2'
      end
    end

    def headers
      {
        "authorization"=>"#{@token}",
        'Content-Type' => 'application/json'
      }
    end

    def post(url, query = {}, body = {})
      HTTParty.post(
        @api_url  + url,
        headers: headers,
        query: query,
        body: body,
        debug_output: $stdout
      )
    end

    def get(url, query = {}, body = {})
      HTTParty.get(
        @api_url2 + url,
        headers: headers,
        query: query,
        body: body,
        debug_output: $stdout
      )
    end

    def download()
      get('', generate_params('GET_DOCUMENT').merge('GUID' => @sale.electronic_bill.identifier))
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