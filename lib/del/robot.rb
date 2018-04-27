module Del
  class Robot
    attr_reader :connection, :router

    def initialize(configuration:)
      @connection = Connection.new(
        configuration: configuration,
        users: users,
        rooms: rooms,
      )
      @router = configuration[:router]
    end

    def get_funky!
      connection.connect(self)
      sleep
    rescue Interrupt
      connection.disconnect
    end

    def receive(message)
      router.route(message)
    end

    def send_message(jid, message)
      connection.deliver(jid, message)
    end

    private

    def users
      @users ||= UserRepository.new
    end

    def rooms
      @rooms ||= RoomRepository.new
    end
  end
end
