module Del
  class Source
    attr_reader :user, :room

    def initialize(user:, room: nil)
      @user = user
      @room = room
    end

    def from?(robot)
      user.attributes.jid == robot.jid.to_s
    end

    def reply(robot, message)
      robot.send_message(user.jid, message, room: room)
    end

    def to_s
      "#{user.mention_name}:#{room}:"
    end
  end
end
