module Del
  class Configuration
    SOCKET_FILE="/tmp/del.sock"
    attr_accessor :default_rooms
    attr_accessor :host
    attr_accessor :jid
    attr_accessor :jid
    attr_accessor :logger
    attr_accessor :muc_domain
    attr_accessor :name
    attr_accessor :password
    attr_accessor :router
    attr_accessor :users
    attr_accessor :socket_file

    def initialize(settings = {})
      @default_rooms = settings.fetch(:rooms, [])
      @host = settings.fetch(:host, 'chat.hipchat.com')
      @jid = settings.fetch(:jid)
      @logger = Logger.new(STDOUT)
      @logger.level = settings.fetch(:log_level, Logger::INFO).to_i
      @muc_domain = settings.fetch(:muc_domain, "conf.hipchat.com")
      @name = settings.fetch(:full_name)
      @password = settings.fetch(:password)
      @router = DefaultRouter.new
      @socket_file = settings.fetch(:socket_file, SOCKET_FILE)
      @users = Repository.new(mapper: User)
    end

    def load(file)
      return if file.nil?
      return Kernel.load(file) if File.exist?(file)
      Net::Hippie.logger = logger
      eval(Net::Hippie::Api.new(file).get, binding)
    end
  end
end
