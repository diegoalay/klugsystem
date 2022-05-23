# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show

    # get the confirmation token sent through get params
    token = params[:confirmation_token]

    # validate that token were sent
    if token.blank?
        respond_with_error("El token es inválido")
    end

    # check if token belongs to an specific user
    user = User.find_by(confirmation_token: token)

    # validate that user were found
    if user.blank?
      respond_with_error("El token es inválido")
    end

    # confirm the user
    respond_with_successful("Usuario confirmado exitosamente")
end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
end
