module Del
  class SocketServer
    def initialize(socket_file:)
      @connection = SocketConnection.new(path: socket_file)
    end

    def run(robot)
      loop do
        @connection.on_receive do |socket|
          line = socket.readline
          Del.logger.debug(line)
          json = JSON.parse(line)
          jid = json['jid']
          robot.send_message(jid, json['message'])
        end
      end
    end
  end
end
