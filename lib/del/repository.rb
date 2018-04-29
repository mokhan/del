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
      @lock.synchronize { @storage[id.to_s] }
    end

    def find_by_value
      @lock.synchronize { @storage.values.find { |x| yield x } }
    end

    def find_all
      @lock.synchronize { @storage.keys }
    end

    def upsert(id, attributes = {})
      Del.logger.debug([id, attributes].inspect)
      @lock.synchronize do
        @storage[id.to_s] = attributes
      end
    end
  end
end