module Del
  class DefaultRouter
    def route(message)
      Del.logger.info(message.to_s)
    end
  end
end
