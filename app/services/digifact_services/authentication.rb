module DigifactServices
  class Authentication

    AUTHENTICATION_URL = 'https://felgttestaws.digifact.com.gt/gt.com.fel.api.v3/api/login/get_token'

    def initialize(account)
      @account = account
    end

    def call(validate)
      if validate || @account.digifact_token.blank?
        generate_token
      elsif @account.digifact_token_expires_at.present?
        if DateTime.iso8601(@account.digifact_token_expires_at) < Time.current
          generate_token
        end
      end
    end

    def generate_token
      resp = authentication

      token_expire_at = nil
      token = nil
      errors = ''
      status = false

      if resp.code.eql? 200
        token_expire_at = resp.parsed_response['expira_en'],
        token = resp.parsed_response['Token']
        status = true
      else
        errors = resp.parsed_response['description']
      end

      @account.assign_attributes(
        digifact_token_expires_at: token_expire_at,
        digifact_token: token,
        digifact_errors: errors,
        digifact_status: status
      )

      @account.save
    end

    def authentication()
      HTTParty.post(
        AUTHENTICATION_URL,
        headers: {
          'Content-Type': 'application/json'
        },
        body: generate_body,
        debug_output: $stdout
      )
    end

    private

    def generate_body
      auth_data = {
        'Username': @account.digifact_username,
        'Password': @account.digifact_password
      }.to_json

      auth_data
    end
  end
end