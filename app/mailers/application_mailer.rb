class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.dig(:smtp, :default_host_url)
  layout 'mailer'

  def send2(to, subject)
    @data = @data.merge({
      url: Rails.application.credentials.dig(:smtp, :default_url)
    })

    mail(to: to, subject: subject)
  end
end
