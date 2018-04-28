module Del
  class DefaultRouter
    def route(message)
      Del.logger.info(message.to_s)

      message.reply(message.text.reverse)
    end
  end
end
