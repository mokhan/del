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
    attr_accessor :rooms
    attr_accessor :router
    attr_accessor :users
    attr_accessor :socket_file

    def initialize
      @default_rooms = ENV.fetch("DEL_ROOMS", '').split(',')
      @host = ENV.fetch("DEL_HOST", 'chat.hipchat.com')
      @jid = ENV.fetch("DEL_JID")
      @logger = Logger.new(STDOUT)
      @logger.level = ENV.fetch('LOG_LEVEL', Logger::INFO).to_i
      @muc_domain = ENV.fetch("DEL_MUC_DOMAIN", "conf.hipchat.com")
      @name = ENV.fetch("DEL_FULL_NAME")
      @password = ENV.fetch("DEL_PASSWORD")
      @rooms = Repository.new
      @router = DefaultRouter.new
      @socket_file = SOCKET_FILE
      @users = Repository.new
    end

    def load(file)
      return if file.nil?
      return Kernel.load(file) if File.exist?(file)

      eval(remote_fetch(file), binding)
    end

    private

    def remote_fetch(url)
      require 'uri'
      require 'net/http'

      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.is_a?(URI::HTTPS)
      response = http.request(Net::HTTP::Get.new(uri.request_uri))
      Del.logger.info("Loading...\n#{response.body}")
      response.body
    end
  end
end
