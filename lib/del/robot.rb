module Del
  class Robot
    attr_reader :connection, :router
    attr_reader :users, :rooms
    attr_reader :name

    def initialize(configuration:)
      @connection = Connection.new(configuration: configuration)
      @name = configuration[:name]
      @router = configuration[:router]
      @users = configuration[:users]
      @rooms = configuration[:rooms]
    end

    def get_funky!
      connection.connect(self)
      sleep
    rescue Interrupt
      connection.disconnect
    end

    def receive(message, source:)
      router.route(Message.new(message, robot: self, source: source))
    end

    def send_message(jid, message)
      connection.deliver(jid, message)
    end
  end
end
