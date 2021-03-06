class ApplicationSystemController < ApplicationController
  include Pundit::Authorization
  before_action :authenticate_user!
  before_action :verify_authorized_module, only: [:index, :update, :new, :destroy, :show, :create]
  before_action :set_account
  before_action :set_query
  before_action :set_account_data
  before_action :logger_request

  include Pundit::Authorization

  def set_account
    @account = current_user.account
  end

  def set_query
    @query = {
      filters: params[:filters]||{},
      pagination: {
        disable: params[:disable_pagination] || params[:disable_pagination] == 'true' ?
          true :
          false,
        per_page: (params[:per_page] ? params[:per_page].to_i : 10),
        current_page: (params[:current_page] ? params[:current_page].to_i : 1),
        order: (params[:order] ? params[:order] : "desc"),
        order_by: (params[:order_by] ? params[:order_by] : "id"),
      }
    }
  end

  def set_account_data
    @data = {
      walmart_billing: @account.walmart_billing?,
      account: @account,
      account_logo: @account.logo,
      menu_items: MenuItem.all,
      branch_office: current_user.branch_office,
      current_user: {
        id: current_user.id,
        email: current_user.email,
        name: current_user.name,
        role: current_user.roles.first,
        abilities: current_user.abilities,
        cash_register: current_user.current_cash_register&.show,
      },
      url: {
        cable: cable_url,
        root: request.base_url.to_s,  path: request.path
      }
    }
  end

  def cable_url
    return 'ws://localhost:3000/cable' if Rails.env == "development"

    'wss://klugsystem.com/cable'
  end

  def logger_request
    current_user.log_request(request, params)
  end

  def verify_authorized_module
    key = params[:controller]
    key = key.gsub('/', '.')

    return if request.format === "json"
    return if request.format === "pdf"

    respond_with_unathorized if !current_user.can?(key)
  end
end
