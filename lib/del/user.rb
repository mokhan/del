module Del
  class User
    attr_reader :jid, :attributes

    def initialize(jid, attributes)
      @jid = jid
      @attributes = attributes || {}
    end

    def mention_name
      attributes[:mention_name]
    end

    def to_s
      YAML.dump(attributes)
    end

    def self.map_from(attributes)
      new(attributes[:id], attributes)
    end
  end
end
