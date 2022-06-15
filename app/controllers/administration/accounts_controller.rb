class Administration::AccountsController < ApplicationSystemController
  def show
    respond_to do |format|
      format.html {}
      format.json do
        respond_with_successful(@account)
      end
    end
  end

  def update
    @account.user_modifier = current_user
    @account.update(account_params)

    if @account.save
      respond_with_successful(@account)
    else
      respond_account_with_error
    end
  end

  def options
    respond_with_successful(Account.options)
  end

  private

  def account_params
    params.fetch(:account, {}).permit(
      :name,
      :billing_identifier,
      :billing_name,
      :billing_address,
      :email,
      :telephone,
      :website,
      :electronic_billing,
      :sale_client_id,
      sale_types: []
    )
  end
end
