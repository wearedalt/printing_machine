require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/png_outputter'

module PrintingMachine
  module Field

    class Barcode < PrintingMachine::Field::BaseField

      def output(value, parameters=nil)
        type             = parameters[:type].to_s.split('_').map {|word| word.capitalize }.join
        offset           = parameters[:offset] || 0
        height           = parameters[:height]
        margin_top       = parameters[:margin_top] || 0
        text_size        = parameters[:text_size]
        xdim             = parameters[:xdim] || 0.7

        barcode          = Object.module_eval("::Barby::#{type}").new(value)
        outputter        = Barby::PrawnOutputter.new(barcode)
        outputter.height = height
        outputter.margin = offset
        outputter.xdim   = xdim
        outputter.y      = (@document.cursor - height - margin_top)

        outputter.annotate_pdf(@document)

        if text_size
          text_width      = @document.width_of(value, size: 8)
          text_position_x = offset + (outputter.width - text_width) / 2
          text_position_y = outputter.y - 10

          @document.draw_text value, at: [text_position_x, text_position_y], size: text_size
        end
      end

    end

  end
end
