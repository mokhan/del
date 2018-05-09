module Del
  class Robot
    attr_reader :jid, :name

    def initialize(configuration: Del.configuration)
      @configuration = configuration
      @jid = configuration.jid
      @name = configuration.name
    end

    def get_funky!(start_server: true)
      Del.logger.info("🔥🔥🔥")
      xmpp_connection.connect(self)
      socket_server.run(self) if start_server
    rescue Interrupt
      xmpp_connection.disconnect
    end

    def receive(message, source:)
      return if source.from?(self)
      configuration.router.route(Message.new(message, robot: self, source: source))
    end

    def send_message(jid, message)
      if user?(jid)
        xmpp_connection.deliver(jid, message)
      else
        xmpp_connection.deliver_to_room(jid, message)
      end
    end

    def execute(request)
      case request['command']
      when 'send_message'
        send_message(request['jid'], request['message'])
        "Sent!"
      else
        "Unknown"
      end
    end

    private

    attr_reader :configuration

    def xmpp_connection
      @xmpp_connection ||= Connection.new(configuration: configuration)
    end

    def socket_server
      @socket_server ||= SocketServer.new(socket_file: configuration.socket_file)
    end

    def user?(jid)
      configuration.users[jid]
    end
  end
end
