# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController

  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    username = sign_in_params[:email]&.downcase&.strip
    resource = User.find_for_database_authentication(email: username)

    return respond_with_error('Usuario no encontrado') unless resource

    unless resource.valid_password?(sign_in_params[:password])
        return respond_with_error('Credenciales incorrectas.')
    end

    sign_in :user, resource

    resource.remember_me!

    return respond_with_successful
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  private

  def sign_in_params
    params.fetch(:user, {}).permit(:email, :password)
  end
end
