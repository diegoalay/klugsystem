class ApplicationSystemController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account
  before_action :set_query
  def set_account
    @account = current_user.account
  end

  def set_query
    @query = {
      filters: params[:filters]
    }
  end
end
