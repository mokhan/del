# frozen_string_literal: true

module Del
  # An XMPP user.
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
      new(attributes['jid'], attributes)
    end
  end
end
