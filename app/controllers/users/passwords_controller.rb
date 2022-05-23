# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  skip_before_action :verify_authenticity_token, only: [:create, :update]

  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  def create

    if params[:user].blank? || params[:user][:email].blank?
      return respond_with_error("Usuario no encontrado")
    end

    user = User.find_by(:email => params[:user][:email])

    if user.blank?
      return respond_with_error("Usuario no encontrado")
    end

    unless user.active
      return respond_with_error("El usuario se encuentra inactivo")
    end

    token = user.generate_password_reset_token

    begin
      user.logs.create({ category: "reset_password_sent" })

      UserMailer.reset_password_instructions(user, token).deliver_now
      respond_with_successful
    rescue => exception
      Honeybadger.notify(exception)
      respond_with_error(exception.message)
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  def update
    super do |resource|
      if resource.errors.empty?
        if resource.reset_password_period_valid?
          resource.update(password_expiration_at: nil)
        end

        resource.logs.create(description: "password_reset_successful")

        sign_in :user, resource

        return respond_with_successful

      else
        errors = resource.errors.full_messages.to_sentence

        resource.logs.create(
          category: "password_reset_error",
          description: errors
        ) if resource.id

        return respond_with_error(errors)
      end
    end
  end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
