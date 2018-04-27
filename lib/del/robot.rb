require 'xmpp4r'
require 'xmpp4r/roster/helper/roster'
require 'xmpp4r/muc/helper/simplemucclient'
require 'xmpp4r/muc/helper/mucbrowser'

module Del
  class User
    def initialize(attributes)
      @attributes = attributes
    end
  end

  class UserRepository
    def initialize
      @users = Set.new
    end

    def create(item)
      @users << User.new(item.attributes)
    end
  end

  class RoomRepository
    def initialize
      @rooms = Set.new
    end

    def upsert(room)
      @rooms << room
    end
  end

  class Robot
    attr_reader :configuration, :users, :rooms

    def initialize(configuration:)
      @configuration = configuration
      @users = UserRepository.new
      @rooms = RoomRepository.new
    end

    def run
      client.on_exception do |error, connection, error_source|
        puts error.inspect
        shut_down
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
      @mention_name = roster[jid].attributes['mention_name']

      client.add_message_callback do |message|
        next if message.type == :error || message.body.nil?
        puts message.inspect
      end
      client.send(Jabber::Presence.new(:chat))
      list_rooms(configuration[:muc_domain]).each do |room|
        rooms.upsert(room)
      end
      sleep
    rescue Interrupt
      shut_down
    end

    private

    def list_rooms(muc_domain)
      Jabber::MUC::MUCBrowser.new(client).muc_rooms(muc_domain).map do |jid, name|
        jid.to_s
      end
    end

    def client
      @client ||= Jabber::Client.new(jid)
    end

    def jid
      jid = Jabber::JID.new(configuration[:jid])
      jid.resource = "bot"
      jid
    end

    def shut_down
      puts "byte me!"
      client.close
    end
  end
end
