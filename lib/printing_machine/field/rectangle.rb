module PrintingMachine
  module Field

    class Rectangle < PrintingMachine::Field::BaseField

      def output(value=nil, parameters=nil)
        point_x = parameters[:point_x]
        point_y = parameters[:point_y]
        width   = parameters[:width]
        height  = parameters[:height]

        @document.rectangle [point_x, point_y], width, height
        @document.stroke
      end
    end
  end
end

