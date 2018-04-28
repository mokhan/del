module Del
  class Message
    attr_reader :text, :robot, :source

    def initialize(text, robot:, source:)
      @text = text
      @robot = robot
      @source = source
    end

    def to_s
      "#{source}: #{text}"
    end
  end
end
