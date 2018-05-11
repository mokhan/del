module Del
  class DefaultRouter
    def initialize(routes = [])
      @routes = routes
    end

    def register(pattern, &block)
      @routes.push(pattern: pattern, command: block)
    end

    def route(message)
      @routes.each do |route|
        next unless matches = route[:pattern].match(message.text)
        begin
          route[:command].call(message, matches)
        rescue StandardError => error
          Del.logger.error(error)
        end
      end
    end
  end
end
