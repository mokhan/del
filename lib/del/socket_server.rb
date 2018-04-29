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
          jid, message = line.split('::')
          robot.send_message(jid, message)
        end
      end
    end
  end
end
