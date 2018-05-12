# frozen_string_literal: true

module Del
  class SendMessage
    def initialize(shell)
      @shell = shell
    end

    def run(jid, message)
      socket = SocketMessage.new(@shell)
      socket.deliver(
        command: :send_message,
        jid: jid,
        message: message
      )
      @shell.say(socket.listen, :green)
    ensure
      socket.close
    end
  end
end
