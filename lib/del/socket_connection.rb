module Del
  class SocketConnection
    def initialize(path:)
      File.unlink(path) if File.exists?(path)
      @server = UNIXServer.new(path)
    end

    def on_receive
      socket = @server.accept
      yield socket
    rescue => error
      Del.logger.error(error)
    ensure
      socket&.close
    end
  end
end
