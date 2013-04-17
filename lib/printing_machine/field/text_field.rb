module PrintingMachine
  module Field

    class TextField < PrintingMachine::Field::BaseField

      def output(value, parameters=nil)
        @document.text value, parameters
      end

    end

  end
end
