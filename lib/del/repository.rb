module Del
  class Repository
    def initialize(storage = {})
      @storage = storage
      @lock = Mutex.new
    end

    def [](id)
      find_by(id)
    end

    def find_by(id)
      @lock.synchronize { @storage[id] }
    end

    def upsert(id, attributes = {})
      Del.logger.debug([id, attributes].inspect)
      @lock.synchronize do
        @storage[id] = attributes
      end
    end
  end
end
