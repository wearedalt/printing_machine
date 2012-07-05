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
        page_template = File.join(@templates_path, @pages[page])
        page          = YAML.load_file(page_template)
        page[:instructions]
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
