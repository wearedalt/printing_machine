require 'printing_machine/analyzer/yaml_analyzer'

module PrintingMachine
  class Generator

    attr_accessor :config
    attr_writer   :transforations

    def initialize(templates_path=nil, template=nil, options={})
      self.config         = PrintingMachine.config.clone
      @templates_path     = templates_path
      @analyzer           = PrintingMachine::Analyzer::YamlAnalyzer.new(templates_path, template, options) # TODO : Move this in the config so we can switch analyzer type later
      @transformations    = PrintingMachine::Transformations.new
      @page_name          = options[:page_name] || :page
    end

    def generate_pdf(data, output_file=nil)
      begin
        generate(data, output_file)
      rescue Exception => e
        config.logger.log "PDF generation failed: ERROR #{e.message}", :error
        config.logger.log "#{e.backtrace.join("\n")}", :error
        raise e
      end
    end

    def transformations=(transformations)
      @transformations = transformations
    end

    private

    def generate(data, output_file=nil)
      parameters = @analyzer.parameters
      options    = @analyzer.options
      fonts      = @analyzer.fonts
      pdf_data   = @transformations.transform(data)
      @document  = PrintingMachine::Document.new(parameters, pdf_data)

      @document.print_pages_numbers options[:print_pages_numbers] if options[:print_pages_numbers]
      @document.register_fonts(fonts)

      page_instructions = @analyzer.get_page(@page_name) # TODO : Find a better name than instructions
      process_page(page_instructions)

      @document.render output_file
    end

  private

    def process_page(instructions)
      instructions.each do |instruction|
        type       = instruction.keys[0]
        parameters = instruction[type]

        @document.public_send("process_#{type}", parameters)
      end
    end

  end
end
