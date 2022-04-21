class ApplicationSystemController < ApplicationController
  include Pundit::Authorization
  before_action :authenticate_user!
  before_action :verify_authorized_module, only: [:index, :update, :new, :destroy, :show, :create]
  before_action :set_account
  before_action :set_query
  before_action :set_account_data

  include Pundit::Authorization

  def set_account
    @account = current_user.account
  end

  def set_query
    @query = {
      filters: params[:filters],
      pagination: {
        disable: params[:disable_pagination] ? params[:disable_pagination] : false,
        per_page: (params[:per_page] ? params[:per_page].to_i : 10),
        current_page: (params[:current_page] ? params[:current_page].to_i : 1),
        order: (params[:order] ? params[:order] : "desc"),
        order_by: (params[:order_by] ? params[:order_by] : "id"),
      }
    }
  end

  def set_account_data
    @data = {
      account: @account.attributes,
      current_user: {
        id: current_user.id,
        email: current_user.email,
        name: current_user.name,
        cash_register_id: current_user.cash_register&.id
      },
      url: {
        root: request.base_url.to_s,  path: request.path
      }
    }
  end

  def verify_authorized_module
    key = params[:controller]
    key = key.gsub('/', '.')

    respond_with_unathorized if !current_user.can?(key) and key.include? 'crm'
  end
end
