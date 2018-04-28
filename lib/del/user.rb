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
  end
end
