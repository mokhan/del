module Del
  class Connection
    attr_reader :configuration, :rooms, :users

    def initialize(configuration:, users:, rooms:)
      @configuration = configuration
      @rooms = rooms
      @users = users
    end

    def connect(robot)
      client.on_exception do |error, connection, error_source|
        Del.logger.error(error)
        disconnect
      end
      client.connect(configuration[:host])
      sleep 0.0001 until client.is_connected?
      client.auth(configuration[:password])
      roster = Jabber::Roster::Helper.new(client, false)
      roster.add_update_callback do |old_item, item|
        users.create(item) if item
      end
      roster.get_roster
      roster.wait_for_roster
      client.add_message_callback do |message|
        next if message.type == :error || message.body.nil?
        robot.receive(message)
      end
      client.send(Jabber::Presence.new(:chat))
      list_rooms(configuration[:muc_domain]).each do |room|
        rooms.upsert(room)
      end
    end

    def deliver(jid, message)
      message = Jabber::Message.new(jid, encode_string(message))
      message.type = :chat
      client.send(message)
    end

    def disconnect
      puts "byte me!"
      client.close
    end

    private

    def client
      @client ||= Jabber::Client.new(jid)
    end

    def jid
      jid = Jabber::JID.new(configuration[:jid])
      jid.resource = "bot"
      jid
    end

    def list_rooms(muc_domain)
      Jabber::MUC::MUCBrowser.new(client).muc_rooms(muc_domain).map do |jid, name|
        jid.to_s
      end
    end

    def encode_string(s)
      s.encode("UTF-8", invalid: :replace, undef: :replace)
    end
  end
end
