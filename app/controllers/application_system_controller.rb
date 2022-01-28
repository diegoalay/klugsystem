class ApplicationSystemController < ApplicationController
  before_action :authenticate_user!
  before_action :set_account

  def set_account
    @account = current_user.account
  end
end
