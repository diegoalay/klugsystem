module DocumentGeneratorServices
  class CombinePdfService
    def initialize(sales, current_user)
      @current_user = current_user
      @sales = sales
      @pdf = CombinePDF.new
    end

    def call
      @sales.each do |sale|
        if sale.is_electronic_billing?
          attachment = DigifactServices::Api.new(@current_user, sale).download['ResponseDATA3']
          decode_base64_content = Base64.decode64(attachment)

          @pdf << CombinePDF.parse(decode_base64_content)
        else
          # TODO MERGE WHICKLED PDF DOCUMENT
        end
      end

      @pdf.to_pdf
    end
  end
end
