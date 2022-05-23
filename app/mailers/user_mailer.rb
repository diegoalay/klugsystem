class UserMailer < ApplicationMailer
  def reset_password_instructions(user, token)
    build_data_from_params({
      path: "/reset_password?reset_password_token=#{token}",
    })

    mail(
      to: email_address_with_name(user.email, user.name),
      subject: 'Cambia tu contraseña'
    )
  end
end
