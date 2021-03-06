module DocumentGeneratorServices
  class PdfService
    def initialize(sale)
      super()

      @sale = sale
      @pdf = Prawn::Document.new
    end

    def call
      @sale.custom_fields.each do |custom_field|
        draw_field(custom_field)
      end

      @pdf
    end

    private

    def set_configurations
      @font_size = 8
    end

    def draw_field(custom_field)
      settings = ::Account::BillingField.find_by(id: custom_field['id'])

      if (settings && !custom_field['value'].blank? && custom_field['visible'])
        color = settings['color'].gsub('#', '')
        position_x = to_pt(settings['position_x'])
        position_y = to_pt(settings['position_y'])

        @pdf.fill_color color

        begin
          @pdf.text_box generate_text(settings['label'], custom_field['value']),
          at: [position_x, position_y],
          color: color,
          size: @font_size = 8
        rescue => exception; end;
      end
    end

    def generate_text label, value
      return value if label.blank?
      return "#{label}: #{value}"
    end

    def to_pt(val)
      return val.to_d * 28.3465
    end
  end
end
