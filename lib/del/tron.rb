# frozen_string_literal: true

module Del
  class Tron
    attr_reader :robot, :configuration

    def initialize(robot, configuration)
      @robot = robot
      @configuration = configuration
    end

    def execute(request)
      {
        change_status: -> { change_status(request) },
        send_message: -> { send_message(request) },
        users: -> { users(request) },
        whoami: -> { whoami(request) },
        whois: -> { JSON.generate(whois(request['q'])) }
      }[request['command'].to_sym]&.call || 'Unknown'
    end

    private

    def whois(jid)
      configuration.users[jid]&.attributes || {}
    end

    def send_message(request)
      robot.send_message(request['jid'], request['message'])
      'Sent!'
    end

    def users(_request)
      JSON.generate(configuration.users.all.map(&:attributes))
    end

    def whoami(_request)
      JSON.generate(whois(robot.jid))
    end

    def change_status(request)
      robot.public_send("#{request['status'].downcase}!", request['message'])
      'Done!'
    end
  end
end
