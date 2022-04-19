module DigifactServices
  class Api

    DEFAULT_API_URL = 'https://felgttestaws.digifact.com.gt/gt.com.fel.api.v3/api/FELRequestV2'
    # DEFAULT_API_URL = 'https://felgtaws.digifact.com.gt/gt.com.fel.api.v3'

    def initialize(current_user)
      @current_user = current_user
    end

    def headers
      {
        "Authorization"=>"#{token}",
        'Content-Type' => 'application/json'
      }
    end

    def post(url, options = {})
      HTTParty.post(
        DEFAULT_API_URL + url,
        headers: headers,
        body: options.merge(live_mode: %i[production? heroku?].any? { |m| Rails.env.send(m) } ? true : false),
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

    def annulment()
      post('', generate_params('ANULAR_FEL_TOSIGN'))
    end

    def generate_params(type)
      {
        NIT: @account.electronic_billing.billing_identifier
        TIPO: type
        FORMAT: 'XML'
        USERNAME: @account.electronic_billing.billing_username.
      }
    end

    def timeify(timestamp)
      DateTime.iso8601 timestamp if timestamp
    end
  end
end