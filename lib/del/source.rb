module Del
  class Source
    attr_reader :user, :room

    def initialize(user:, room: nil)
      @user = user
      @room = room
    end

    def to_s
      "#{user.mention_name}:#{room}:"
    end
  end
end
