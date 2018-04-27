module Del
  class Robot
    attr_reader :connection, :users, :rooms

    def initialize(configuration:)
      @users = UserRepository.new
      @rooms = RoomRepository.new
      @connection = Connection.new(
        configuration: configuration,
        users: users,
        rooms: rooms,
      )
    end

    def run
      connection.connect(self)
      sleep
    rescue Interrupt
      connection.disconnect
    end

    def receive(message)
      return if message.type == :error || message.body.nil?
      send_message(message.from, message.body)
    end

    def send_message(jid, message)
      connection.deliver(jid, message)
    end
  end
end
