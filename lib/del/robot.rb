# frozen_string_literal: true

module Del
  # A funky robo-sapien.
  class Robot
    attr_reader :jid, :name

    def initialize(configuration: Del.configuration)
      @configuration = configuration
      @jid = configuration.jid
      @name = configuration.name
    end

    def get_funky!(start_server: true)
      Del.logger.info('🔥🔥🔥')
      xmpp_connection.connect(self)
      if start_server
        deltron = Del::Tron.new(self, configuration)
        socket_server.run(deltron)
      end
    rescue Interrupt
      xmpp_connection.disconnect
    end

    def receive(message, source:)
      return if source.from?(self)
      configuration.router.route(
        Message.new(message, robot: self, source: source)
      )
    end

    def send_message(jid, message)
      if user?(jid)
        xmpp_connection.deliver(jid, message)
      else
        xmpp_connection.deliver_to_room(jid, message)
      end
    end

    {
      away!: :away,
      busy!: :dnd,
      offline!: :xa,
      online!: :chat
    }.each do |name, value|
      define_method name do |message = nil|
        xmpp_connection.update_status(value, message: message)
      end
    end

    private

    attr_reader :configuration

    def xmpp_connection
      @xmpp_connection ||= XMPPConnection.new(configuration: configuration)
    end

    def socket_server
      @socket_server ||=
        SocketServer.new(socket_file: configuration.socket_file)
    end

    def user?(jid)
      configuration.users[jid]
    end
  end
end
