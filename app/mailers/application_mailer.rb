class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.dig(:smtp, :default_host_url)
  layout 'mailer'

  def build_data_from_params(params)
    @data = {} if @data.blank?
    @data = @data.merge({
      url: Rails.application.credentials.dig(:smtp, :default_url)
    })

    @data = @data.merge(params)
  end
end
