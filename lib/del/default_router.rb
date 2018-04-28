module Del
  class DefaultRouter
    attr_reader :logger

    def initialize(logger = Del.logger)
      @logger = logger
      @routes = []
    end

    def register(pattern, &block)
      @routes.push(pattern: pattern, command: block)
    end

    def route(message)
      logger.info(message.to_s)
      @routes.each do |route|
        if route[:pattern].match(message.text)
          route[:command].call(message)
        end
      end
    end
  end
end
