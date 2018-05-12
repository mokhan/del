# frozen_string_literal: true

module Del
  class SocketMessage
    def initialize(shell, socket_file:)
      @shell = shell
      @socket_file = socket_file
    end

    def deliver(payload)
      socket.puts(message_for(payload))
    rescue EOFError => error
      @shell.say error.message, :red
    rescue Errno::ECONNREFUSED => error
      @shell.say error.message, :red
      @shell.say 'You must start the del server first.', :yellow
    end

    def listen
      socket.readline
    end

    def close
      socket&.close
    end

    private

    def message_for(payload)
      JSON.generate(payload)
    end

    def socket
      @socket ||= UNIXSocket.new(@socket_file)
    end
  end
end
