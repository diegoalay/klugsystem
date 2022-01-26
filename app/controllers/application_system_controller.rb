class ApplicationSystemController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account

  def set_account
    @account = current_user.account
  end

  def respond_with_successful(data = nil)
    response_body = { successful: true }
    response_body[:data] = data
    render status: 200, json: response_body.to_json
  end

  def respond_with_error(message = "", details = [])
    render status: 200, json: {
      successful: false,
      error: {
        message: message,
        details: details
      }
    }.to_json
  end

  def respond_with_not_found
    render status: 404, json: {
      successful: false,
      error: {
          message: 'Not found',
          details: []
      }
    }.to_json
  end
end
