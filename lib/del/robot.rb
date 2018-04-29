module Del
  class Robot
    attr_reader :connection, :router, :server
    attr_reader :users, :rooms
    attr_reader :jid, :name

    def initialize(configuration:)
      @connection = Connection.new(configuration: configuration)
      @jid = configuration.jid
      @name = configuration.name
      @router = configuration.router
      @users = configuration.users
      @rooms = configuration.rooms
      @server = SocketServer.new(socket_file: configuration.socket_file)
    end

    def get_funky!(start_server: true)
      Del.logger.info("It's fire! 🔥")
      connection.connect(self)
      server.run(self) if start_server
    rescue Interrupt
      connection.disconnect
    end

    def receive(message, source:)
      return if source.from?(self)
      router.route(Message.new(message, robot: self, source: source))
    end

    def send_message(jid, message)
      if user?(jid)
        connection.deliver(jid, message)
      else
        connection.deliver_to_room(jid, message)
      end
    end

    private

    def user?(jid)
      users[jid]
    end
  end
end
