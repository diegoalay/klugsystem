module DigifactServices
  class Api
    include DigifactServices::GenerateBill
    include DigifactServices::AnulateBill

    DEFAULT_API_URL = 'https://felgttestaws.digifact.com.gt/gt.com.fel.api.v3/api/FELRequestV2'
    DEFAULT_API_URL = 'https://felgtaws.digifact.com.gt/gt.com.fel.api.v3/api/FelRequestV2' if Rails.env == 'production'

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
        DEFAULT_API_URL + url,
        headers: headers,
        query: query,
        body: body,
        debug_output: $stdout
      )
    end

    def get(url)
      HTTParty.get(
        DEFAULT_API_URL + url,
        headers: headers,
        debug_output: $stdout
      )
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