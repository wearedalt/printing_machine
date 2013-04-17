require "printing_machine/logger"

module PrintingMachine
  Config = Struct.new(:_logger, :raise_errors, :env_namespace) do

    def self.default
      config = new
      config._logger = Logger.new
      config.raise_errors = true
      config
    end

    alias_method :logger, :_logger

    def logger=(logger)
      _logger.subject = logger
    end

    def log_level=(level)
      _logger.level = level
    end

    def log=(log)
      if log == true
        self._logger = Logger.new
      else
        self._logger = NullLogger.new
      end
    end

    def clone
      config = super
      config._logger = config._logger.clone
      config
    end

  end
end
