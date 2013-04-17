require "logger"

module PrintingMachine
  class Logger

    def initialize(device = $stdout)
      self.device = device
    end

    attr_accessor :device

    def log(message, level = :debug, options = {})
      log_raw level, message
    end

    attr_writer :subject, :level, :filter

    def subject
      @subject ||= ::Logger.new(device)
    end

    def level
      @level ||= :debug
    end

    def filter
      @filter ||= []
    end

    private

    def log_raw(level, message)
      subject.send(level, message)
    end

  end
end
