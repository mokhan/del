# frozen_string_literal: true

module Del
  class SendMessage
    def initialize(shell, socket_file:)
      @shell = shell
      @socket = SocketMessage.new(@shell, socket_file: socket_file)
    end

    def run(jid, message)
      @socket.deliver(
        command: :send_message,
        jid: jid,
        message: message
      )
      @shell.say(@socket.listen, :green)
    ensure
      @socket.close
    end
  end
end
