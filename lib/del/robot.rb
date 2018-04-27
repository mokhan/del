module Del
  class Robot
    attr_reader :connection

    def initialize(configuration:)
      @connection = Connection.new(
        configuration: configuration,
        users: users,
        rooms: rooms,
      )
    end

    def get_funky!
      connection.connect(self)
      sleep
    rescue Interrupt
      connection.disconnect
    end

    def receive(message)
      send_message(message.from, message.body)
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
