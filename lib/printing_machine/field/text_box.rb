module PrintingMachine
  module Field

    class TextBox < PrintingMachine::Field::BaseField

      def output(value, parameters=nil)
        offset      = parameters[:offset] || 0
        width       = parameters[:width] || 0
        text        = value
        size        = parameters[:size]

        coordinates = parameters[:at] || [offset, @document.cursor]

        box = @document.bounding_box coordinates, width: width do
          @document.text text, size: size
        end

        @document.move_up box.height
      end

    end

  end
end
