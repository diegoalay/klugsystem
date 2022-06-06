module FraguaServices
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

      if (settings && !custom_field['value'].blank?)
        color = settings['color'].gsub('#', '')
        position_x = to_pt(settings['position_x'])
        position_y = to_pt(settings['position_y'])

        @pdf.fill_color color
        @pdf.text_box "#{custom_field['title']}: #{custom_field['value']}",
          at: [position_x, position_y],
          color: color,
          size: @font_size = 8
      end
    end

    def to_pt(val)
      return val.to_d * 28.3465
    end
  end
end
