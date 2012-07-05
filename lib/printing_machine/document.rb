module PrintingMachine
  class Document

    def initialize(parameters, data)
      @document = ::Prawn::Document.new(parameters)
      @data     = data
    end

    def add_page
      @document.start_new_page
    end

    def process_command(parameters)
      class_name = parameters.keys[0].to_s.split('_').map {|word| word.capitalize }.join
      klass      = Object.module_eval("::PrintingMachine::Command::#{class_name}")
      value      = parameters[parameters.keys[0]]
      output     = klass.new(@document)

      output.output(value)
    end

    def print_pages_numbers(format)
      options = {
        :at => [@document.bounds.right - 140, @document.bounds.top + 10], # TODO : Optimize the alignment not using a hardcoded value
        :width => 150,
        :align => :right,
        :start_count_at => 1,
        :size => 7
      }

      @document.number_pages format, options
    end

    def process_field(parameters)
      data_field = parameters.keys[0]
      value      = @data[data_field]
      klass      = Object.module_eval("::PrintingMachine::Field::#{parameters[data_field][:type]}")
      output     = klass.new(@document)

      output.output(value, parameters[data_field][:params])
    end

    def render(file=nil)
      if file
        @document.render_file(file)
      else
        @document.render
      end
    end

    def register_fonts(fonts)
      fonts.each do |font, parameters|
        parameters.each do |style, path|
          @document.font_families.update(font.to_s => {
            style => path
          })
        end
      end
    end

  end
end
