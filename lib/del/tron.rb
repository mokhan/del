# frozen_string_literal: true

module Del
  class Tron
    attr_reader :robot, :configuration

    def initialize(robot, configuration)
      @robot = robot
      @configuration = configuration
    end

    def execute(request)
      command_for(request)&.call(request) || 'Unknown'
    rescue StandardError => error
      error.message
    end

    private

    def commands
      {
        change_status: ->(request) { change_status(request) },
        send_message: ->(request) { send_message(request) },
        users: ->(request) { users(request) },
        whoami: ->(request) { whoami(request) },
        whois: ->(request) { JSON.generate(whois(request['q'])) }
      }
    end

    def command_for(request)
      commands[request['command'].to_sym]
    end

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
    rescue NoMethodError
      'Error: Invalid status'
    end
  end
end
