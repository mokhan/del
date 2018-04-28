module Del
  class Configuration
    attr_accessor :default_rooms
    attr_accessor :host
    attr_accessor :jid
    attr_accessor :jid
    attr_accessor :logger
    attr_accessor :muc_domain
    attr_accessor :name
    attr_accessor :password
    attr_accessor :rooms
    attr_accessor :router
    attr_accessor :users

    def initialize
      @default_rooms = ENV.fetch("DEL_ROOMS", '').split(',')
      @host = ENV.fetch("DEL_HOST", 'chat.hipchat.com')
      @jid = ENV.fetch("DEL_JID")
      @logger = Logger.new(STDOUT)
      @logger.level = Logger::INFO
      @muc_domain = ENV.fetch("DEL_MUC_DOMAIN", "conf.hipchat.com")
      @name = ENV.fetch("DEL_FULL_NAME")
      @password = ENV.fetch("DEL_PASSWORD")
      @rooms = Repository.new
      @router = DefaultRouter.new
      @users = Repository.new
    end
  end
end
