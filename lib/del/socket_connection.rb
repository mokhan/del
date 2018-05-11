# frozen_string_literal: true

module Del
  class SocketConnection
    def initialize(path:)
      File.unlink(path) if File.exist?(path)
      @server = UNIXServer.new(path)
    end

    def on_receive
      socket = @server.accept
      yield socket
    rescue StandardError => error
      Del.logger.error(error)
    ensure
      socket&.close
    end
  end
end
