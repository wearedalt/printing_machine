require "printing_machine/logger"

module PrintingMachine
  class NullLogger < Logger

    def log(*)
    end

  end
end
