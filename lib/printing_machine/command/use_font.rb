module PrintingMachine
  module Command

    class UseFont < PrintingMachine::Command::BaseCommand

      def output(value)
        @document.font value
      end

    end

  end
end
