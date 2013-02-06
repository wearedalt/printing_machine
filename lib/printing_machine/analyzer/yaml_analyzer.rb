module PrintingMachine
  module Analyzer
    class YamlAnalyzer

      attr_reader :parameters, :options, :fonts, :pages

      def initialize(templates_path, template)
        @templates_path = templates_path
        @template       = YAML.load_file(File.join(templates_path, template))

        self.analyze_template
      end

      def get_page(page)
        file_names = @pages[page].is_a?(Array) ? @pages[page] : [@pages[page]]

        result = { instructions: [] }
        file_names.each do |file_name|
          new_yaml              = YAML.load_file(File.join(@templates_path, file_name))
          result[:instructions] = result[:instructions] + new_yaml[:instructions]
        end

        result[:instructions]
      end

    protected

      def analyze_template
        @parameters = @template[:parameters]
        @options    = @template[:options]
        @fonts      = @template[:fonts]
        @pages      = @template[:pages]
      end

    end
  end
end
