module Del
  class SocketServer
    def initialize(connection = SocketConnection.new)
      @connection = connection
    end

    def run(robot)
      loop do
        @connection.on_receive do |socket|
          Del.logger.info(socket.readline)
        end
      end
    end
  end
end
