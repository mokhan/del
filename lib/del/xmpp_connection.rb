# frozen_string_literal: true

module Del
  # An XMPP Connection
  class XMPPConnection
    attr_reader :configuration

    def initialize(configuration:)
      @configuration = configuration
      @rooms = {}
    end

    def connect(robot)
      record_exceptions
      connect_to_xmpp_server
      roster = discover_users
      listen_for_direct_messages(robot)
      update_status(:chat)
      discover_rooms(robot, roster)
    end

    def deliver(jid, message)
      message = Jabber::Message.new(jid, encode_string(message))
      message.type = :chat
      client.send(message)
    end

    def deliver_to_room(jid, message)
      @rooms[jid.strip.to_s]&.say(encode_string(message))
    end

    def disconnect
      Del.logger.info('byte me!')
      client.close
    rescue IOError, SystemCallError => error
      Del.logger.error(error)
    end

    # :chat, :away, :dnd, :xa
    def update_status(show = :chat, message: nil)
      client.send(Jabber::Presence.new(show, message))
    end

    private

    def client
      @client ||= Jabber::Client.new(jid)
    end

    def jid
      @jid ||= jid_for(configuration.jid, 'chat.hipchat.com', 'bot')
    end

    def encode_string(item)
      item.to_s.encode('UTF-8', invalid: :replace, undef: :replace)
    end

    def jid_for(jid, domain, resource)
      jid = Jabber::JID.new(jid)
      jid.resource = resource
      unless jid.node
        jid.node = jid.domain
        jid.domain = domain
      end
      jid
    end

    def record_exceptions
      client.on_exception do |error, _connection, _error_source|
        Del.logger.error(error)
        disconnect
      end
    end

    def connect_to_xmpp_server
      client.connect(configuration.host)
      sleep 0.0001 until client.is_connected?
      client.auth(configuration.password)
    end

    def discover_users
      roster = Jabber::Roster::Helper.new(client, false)
      roster.add_update_callback do |_old_item, item|
        configuration.users.upsert(item['jid'], item.attributes) if item
      end
      roster.get_roster
      roster.wait_for_roster
      roster
    end

    def listen_for_direct_messages(robot)
      client.add_message_callback do |message|
        next if message.type == :error || message.body.nil?
        user = configuration.users.find(message.from.strip)
        robot.receive(message.body, source: Source.new(user: user))
      end
    end

    def discover_rooms(robot, roster)
      configuration.default_rooms.each do |room|
        room_jid = jid_for(room, configuration.muc_domain.dup, robot.name)
        stripped_jid = room_jid.strip.to_s
        next if @rooms[stripped_jid]

        muc = @rooms[stripped_jid] = Jabber::MUC::SimpleMUCClient.new(client)
        listen_for_room_messages(muc, room_jid, robot, roster)
      end
    end

    def listen_for_room_messages(multi_user_chat, room_jid, robot, roster)
      multi_user_chat.on_message do |_, nickname, message|
        Del.logger.debug([nickname, message].inspect)
        user = find_user_with(nickname, roster)
        source = Source.new(user: user, room: room_jid.strip.to_s)
        robot.receive(message, source: source)
      end
      multi_user_chat.join(room_jid)
    end

    def find_user_with(nickname, roster)
      other_jid = roster.items.find { |_jid, item| item.iname == nickname }
      user = configuration.users.find(other_jid)
      user.nil? ? User.new(other_jid[0], other_jid[1]) : user
    end
  end
end
