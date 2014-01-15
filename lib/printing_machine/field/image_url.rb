module PrintingMachine
  module Field

    class ImageUrl < PrintingMachine::Field::BaseField

      def output(value, parameters=nil)


        offset     = parameters[:offset] || 0
        width      = parameters[:width] || 0
        height     = parameters[:height] || 0
        pos_x      = parameters[:pos_x] || 0
        pos_y      = parameters[:pos_y]  || 0
        url        = open(value)


        image = @document.image url, at: [pos_x, pos_y] do

        end


      end

    end

  end
end

