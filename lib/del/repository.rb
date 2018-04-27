module Del
  class Repository
    def initialize(storage = {})
      @storage = storage
    end

    def find_by(id)
      @storage[id]
    end

    def upsert(id, attributes = {})
      Del.logger.debug([id, attributes].inspect)
      @storage[id] = attributes
    end
  end
end
