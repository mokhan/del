  class RoomRepository
    def initialize
      @rooms = Set.new
    end

    def upsert(room)
      @rooms << room
    end
  end
