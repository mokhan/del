# frozen_string_literal: true

module Del
  # A Socket server for client/server communication
  # overs a UNIX socket.
  class SocketServer
    def initialize(socket_file:)
      @connection = SocketConnection.new(path: socket_file)
    end

    def run(robot)
      loop do
        @connection.on_receive do |socket|
          line = socket.readline
          Del.logger.debug(line)
          socket.write(robot.execute(JSON.parse(line)))
        end
      end
    end
  end
end
