# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  def create
    resource = User.find_for_database_authentication(email: sign_in_params[:email])

    return responseWithError('User not found') unless resource

    unless resource.valid_password?(sign_in_params[:password])
        return responseWithError('Invalid Credentials')
        redirect_to "/login"
    end

    # unless resource.confirmed?
    #     return responseWithError('devise.errors.custom.confirmation_required')
    # end

    sign_in :user, resource

    redirect_to "/"
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  # protected

  def sign_in_params
    params.fetch(:user, {}).permit(:email, :password)
  end
end
