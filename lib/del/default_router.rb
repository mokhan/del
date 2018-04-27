module Del
  class DefaultRouter
    def route(message)
      Del.logger.debug(message)
    end
  end
end
