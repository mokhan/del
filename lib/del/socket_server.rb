module Del
  class SocketServer
    def initialize(connection = SocketConnection.new)
      @connection = connection
    end

    def run(robot)
      loop do
        @connection.on_receive do |socket|
          line = socket.readline
          Del.logger.debug(line)
          robot.process(line)
        end
      end
    end
  end
end
