module Del
  class Message
    PREFIX = "/code"
    attr_reader :text, :robot, :source

    def initialize(text, robot:, source:)
      @text = text
      @robot = robot
      @source = source
    end

    def reply(message)
      source.reply(robot, message)
    end

    def execute_shell(command)
      reply("Okay, I'm on it!")
      ShellCommand.new(command).run do |line|
        if block_given?
          yield line
        else
          reply("#{PREFIX} #{line}")
        end
      end
    end

    def to_s
      "#{source}: #{text}"
    end
  end
end
