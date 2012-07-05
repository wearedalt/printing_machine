module PrintingMachine
  module Command

    class MoveDown < PrintingMachine::Command::BaseCommand

      def output(value)
        @document.move_down value
      end

    end

  end
end
