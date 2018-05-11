# frozen_string_literal: true

module Del
  # This class is a facade for backend data storage.
  class Repository
    def initialize(storage: {}, mapper:)
      @storage = storage
      @mapper = mapper
      @lock = Mutex.new
    end

    def [](id)
      find(id)
    end

    def find(id)
      @lock.synchronize do
        @mapper.map_from(@storage[id.to_s])
      end
    end

    def all
      @lock.synchronize do
        @storage.map do |(_, value)|
          @mapper.map_from(value)
        end
      end
    end

    def upsert(id, attributes = {})
      @lock.synchronize do
        @storage[id.to_s] = attributes
      end
    end
  end
end
