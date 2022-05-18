class SaleMailer < ApplicationMailer
  def send_sale(sale, current_user, email = nil)
    if email.nil?
      email = sale.client.billing_email
    end

    return if email.blank?

    @data = {
      client: {
        name: sale.client.full_name
      },
      account: {
        telephone: sale.account.telephone,
        website: sale.account.website,
        email: sale.account.email,
        name: sale.account.name
      }
    }


    add_pdf!(sale, current_user)
    if mail(to: email, subject: 'Información Factura Electrónica')
      sale.activities.create(
        category: 'sale_sent',
        user_creator: current_user,
        description: email
      )
    end
  end

  private

  def add_pdf!(sale, current_user)
    file = generate_pdf(sale, current_user)
    attachments["factura.pdf"] = file
  end

  def generate_pdf(sale, current_user)
    if sale.electronic_bill.present? && sale.electronic_bill.identifier

      attachment = DigifactServices::Api.new(current_user, sale).download['ResponseDATA3']
      decode_base64_content = Base64.decode64(attachment)

      decode_base64_content
    else
      @details = sale.show
      WickedPdf.new.pdf_from_string(
        render(
          template: 'sales/show.pdf.html.erb',
          layout: 'layouts/pdf.html.erb',
          viewport_size: '1280x1024',
          pdf: "factura.pdf"
        )
      )
    end
  end
end
