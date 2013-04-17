require 'barby'
require 'barby/barcode/code_128'
require 'barby/outputter/png_outputter'

module PrintingMachine
  module Field

    #OPTIMIZE : This class could be greatly refactored and optimized

    class Table < PrintingMachine::Field::BaseField

      AVAILABLE_COLUMN_OPTIONS = [:width, :text_size, :align, :header_size, :type]

      def output(value, parameters=nil)
        columns_params  = []
        cells_params    = merge_cells_options(parameters)
        row_params      = merge_row_options(parameters)
        rows            = []
        header          = []

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


          table.cells.borders = cells_params[:borders]
          table.cells.height  = cells_params[:height] if cells_params[:height]
          table.cells.padding = cells_params[:padding] if cells_params[:padding]

          parameters[:columns].each_with_index do |_, i|
            table.row(0).column(i).size = columns_params[i][:header_size]

            unless columns_params[i][:text_size] == :false
              table.row(1..value.size).column(i).size = columns_params[i][:text_size]
              table.column(i).align                   = (columns_params[i][:align] || :left)
            end

            table.column(i).width = columns_params[i][:width]
          end

          table.rows(0..table.row_length).each do |row|
            row.borders = row_params[:borders]
          end

          table.rows(0).borders                    = row_params[:header_borders]
          table.rows(table.row_length - 1).borders = row_params[:footer_borders]

        end

      end

    private

      def get_barcode(value)
        return unless value
        barcode       = ::Barby::Code128C.new(value)
        barcode_image = barcode.to_datastream(xdim: 2, height: 70)
        path          = "tmp/tmp_barcode_#{value}.png"
        barcode_image.save(path) # OPTIMIZE : Is there a way to avoid writing a file ?
        image         = { image: path, scale: 0.35} # TODO : Make it possible to chose the size
      end

      def get_text(value)
        value
      end

      def merge_cells_options(parameters)
        default_borders_options = [:top, :bottom]
        cells_params            =  parameters[:cells] ? parameters[:cells] : {}
        cells_params[:borders]  = default_borders_options unless cells_params[:borders]
        cells_params
      end

      def merge_row_options(parameters)
        default_borders_options        = [:top, :bottom]
        default_header_borders_options = [:top, :bottom]
        default_footer_borders_options = [:bottom]
        row_params                     = parameters[:row] ? parameters[:row] : {}
        row_params[:borders]           = default_borders_options unless row_params[:borders]
        row_params[:header_borders]    = default_header_borders_options unless row_params[:header_borders]
        row_params[:footer_borders]    = default_footer_borders_options unless row_params[:footer_borders]
        row_params
      end

    end

  end
end
