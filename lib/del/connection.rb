# frozen_string_literal: true

module Del
  # An XMPP Connection
  class Connection
    attr_reader :configuration

    def initialize(configuration:)
      @configuration = configuration
      @mucs = {}
    end

    def connect(robot)
      client.on_exception do |error, _connection, _error_source|
        Del.logger.error(error)
        disconnect
      end
      client.connect(configuration.host)
      sleep 0.0001 until client.is_connected?
      client.auth(configuration.password)
      roster = Jabber::Roster::Helper.new(client, false)
      roster.add_update_callback do |_old_item, item|
        configuration.users.upsert(item['jid'], item.attributes) if item
      end
      roster.get_roster
      roster.wait_for_roster
      client.add_message_callback do |message|
        next if message.type == :error || message.body.nil?
        user = configuration.users.find(message.from.strip)
        robot.receive(message.body, source: Source.new(user: user))
      end
      client.send(Jabber::Presence.new(:chat))
      configuration.default_rooms.each do |room|
        Del.logger.debug("Joining room '#{room}' as '#{robot.name}'")
        room_jid = jid_for(room, configuration.muc_domain.dup, robot.name)
        stripped_jid = room_jid.strip.to_s
        next if @mucs[stripped_jid]

        muc = Jabber::MUC::SimpleMUCClient.new(client)
        @mucs[stripped_jid] = muc
        muc.on_message do |_, nickname, message|
          Del.logger.debug([nickname, message].inspect)
          other_jid = roster.items.find { |_jid, item| item.iname == nickname }
          source = Source.new(
            user: User.new(other_jid[0], other_jid[1]),
            room: stripped_jid
          )
          robot.receive(message, source: source)
        end
        muc.join(room_jid)
      end
      # list_rooms(configuration.muc_domain).each do |room|
      # rooms.upsert(room)
      # end
    end

    def deliver(jid, message)
      message = Jabber::Message.new(jid, encode_string(message))
      message.type = :chat
      client.send(message)
    end

    def deliver_to_room(jid, message)
      muc = @mucs[jid.strip.to_s]
      muc&.say(encode_string(message))
    end

    def disconnect
      Del.logger.info('byte me!')
      client.close
    rescue IOError, SystemCallError => error
      Del.logger.error(error)
    end

    private

    def client
      @client ||= Jabber::Client.new(jid)
    end

    def jid
      @jid ||= jid_for(configuration.jid, 'chat.hipchat.com', 'bot')
    end

    def list_rooms(muc_domain)
      browser = Jabber::MUC::MUCBrowser.new(client)
      browser.muc_rooms(muc_domain).map do |jid, _name|
        jid.to_s
      end
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
  end
end
