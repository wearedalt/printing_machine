require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/png_outputter'

module PrintingMachine
  module Field

    #OPTIMIZE : This class could be greatly refactored and optimized

    class Table < PrintingMachine::Field::BaseField

      AVAILABLE_COLUMN_OPTIONS = [:width, :text_size, :align, :header_size, :type]

      def output(value, parameters=nil)
        columns_params = []
        rows = []
        header = []

        parameters[:columns].each do |column, params|
          column_params = Hash.new
          AVAILABLE_COLUMN_OPTIONS.each do |option|
            column_params[option] = params[option] if params[option]
          end
          columns_params << column_params

          header << params[:title]
        end

        rows << header

        value.each do |item|
          row = []
          parameters[:columns].each do |column, params|
            col_type = params[:type] ? params[:type] : :text
            row << self.send("get_#{col_type}", item[column])
          end
          rows << row
        end

        @document.table rows do |table|
          table.cells.borders = [:top, :bottom]
          parameters[:columns].each_with_index do |_, i|
              table.row(0).column(i).size = columns_params[i][:header_size]

              unless columns_params[i][:text_size] == :false
                table.row(1..value.size).column(i).size = columns_params[i][:text_size]
                table.column(i).align = (columns_params[i][:align] || :left)
              end

              table.column(i).width = columns_params[i][:width]
          end
        end

      end

    private

      def get_barcode(value)
        return unless value
        barcode = ::Barby::Code128C.new(value)
        barcode_image = barcode.to_datastream(xdim: 2, height: 70)
        path = 'tmp/tmp_barcode.png'
        barcode_image.save(path) # OPTIMIZE : Is there a way to avoid writing a file ?
        image = { image: path, scale: 0.35} # TODO : Make it possible to chose the size
      end

      def get_text(value)
        value
      end

    end

  end
end
