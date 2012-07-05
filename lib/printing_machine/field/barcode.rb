require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/png_outputter'

module PrintingMachine
  module Field

    class Barcode < PrintingMachine::Field::BaseField

      def output(value, parameters=nil)

        type          = parameters[:type].to_s.split('_').map {|word| word.capitalize }.join
        offset        = parameters[:offset] || 0
        height        = parameters[:height]
        width         = parameters[:width]
        text_size     = parameters[:text_size]
        barcode       = Object.module_eval("::Barby::#{type}").new(value)
        barcode_image = barcode.to_image(margin: 0).to_blob
        io            = StringIO.new(barcode_image)

        @document.image(io, width: width, height: height, position: offset)

        if text_size
          text_width    = @document.width_of(value, size: 8)
          text_position = offset + (width - text_width) / 2

          @document.move_down(10)
          @document.draw_text value, at: [text_position, @document.cursor], size: text_size
        end
      end

    end

  end
end
