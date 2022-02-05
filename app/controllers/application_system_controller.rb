class ApplicationSystemController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account
  before_action :set_query
  before_action :set_account_data

  def set_account
    @account = current_user.account
  end

  def set_query
    @query = {
      filters: params[:filters],
      pagination: {
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
        name: current_user.name
      },
      url: {
        root: request.base_url.to_s,  path: request.path
      }
    }
  end
end
