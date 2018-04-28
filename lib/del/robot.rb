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
      @server = SocketServer.new
    end

    def get_funky!
      Del.logger.info("It's fire! 🔥")
      connection.connect(self)
      server.run(self)
    rescue Interrupt
      connection.disconnect
    end

    def receive(message, source:)
      return if source.from?(self)
      router.route(Message.new(message, robot: self, source: source))
    end

    def send_message(jid, message, room: nil)
      if room.nil?
        connection.deliver(jid, message)
      else
        connection.deliver_to_room(room, message)
      end
    end
  end
end
