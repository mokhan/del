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
        if route[:pattern].match(message.text)
          route[:command].call(message)
        end
      end
    end
  end
end
