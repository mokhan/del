module Del
  class Repository
    def initialize(storage = Set.new)
      @storage = storage
    end

    def upsert(item)
      Del.logger.debug(item)
      @storage << item
    end
  end
end
