# frozen_string_literal: true

module Del
  # This represents the source of a chat message.
  class Source
    attr_reader :user, :room

    def initialize(user:, room: nil)
      @user = user
      @room = room
    end

    def from?(robot)
      user.jid == robot.jid.to_s
    end

    def reply(robot, message)
      robot.send_message(room || user.jid, message)
    end

    def to_s
      "#{user.mention_name}#{room ? ":#{room}" : nil}"
    end
  end
end
