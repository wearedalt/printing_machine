module PrintingMachine
  module Field

    class LabeledText < PrintingMachine::Field::BaseField

      def output(value, parameters=nil)

        title      = parameters[:title]
        title_size = parameters[:title_size]
        offset     = parameters[:offset] || 0
        width      = parameters[:width] || 0
        text       = value
        size       = parameters[:size]

        box = @document.bounding_box [offset, @document.cursor], width: width do
          @document.text title, size: title_size
          @document.move_down 2
          @document.text text, size: size
        end

        @document.move_up box.height
      end

    end

  end
end

