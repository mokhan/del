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
      command = Array(command).flatten.join(' ')
      reply("Okay, I will run #{command}.")
      success = false
      Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
        stdout.each_line do |line|
          yield line if block_given?
          reply("#{PREFIX} #{line}")
        end
        stderr.each_line do |line|
          yield line if block_given?
          reply("#{PREFIX} #{line}")
        end
        success = wait_thr.value.success?
      end
      success
    end

    def to_s
      "#{source}: #{text}"
    end
  end
end
