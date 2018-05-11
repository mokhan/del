module Del
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

    def find_all
      @lock.synchronize { @storage.keys }
    end

    def upsert(id, attributes = {})
      @lock.synchronize do
        @storage[id.to_s] = attributes
      end
    end
  end
end
