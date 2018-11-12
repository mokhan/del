# frozen_string_literal: true

module Del
  # This is used to contain all configuration.
  class Configuration
    SOCKET_FILE = '/tmp/del.sock'
    attr_accessor :router
    attr_accessor :users
    attr_writer :default_rooms
    attr_writer :host
    attr_writer :jid
    attr_writer :logger
    attr_writer :muc_domain
    attr_writer :name
    attr_writer :password
    attr_writer :socket_file

    def initialize(settings = {})
      @settings = settings
      @router = DefaultRouter.new
      @users = Repository.new(mapper: User)
    end

    def jid
      @jid ||= settings.fetch(:jid)
    end

    def host
      @host ||= settings.fetch(:host, 'chat.hipchat.com')
    end

    def muc_domain
      @muc_domain ||= settings.fetch(:muc_domain, 'conf.hipchat.com')
    end

    def name
      @name ||= settings.fetch(:full_name)
    end

    def password
      @password ||= settings.fetch(:password)
    end

    def logger
      @logger ||=
        begin
          x = Logger.new(STDOUT)
          x.level = settings.fetch(:log_level, Logger::INFO).to_i
          x
        end
    end

    def socket_file
      @socket_file ||= settings.fetch(:socket_file, SOCKET_FILE)
    end

    def default_rooms
      @default_rooms ||= settings.fetch(:rooms, [])
    end

    def load(file)
      return if file.nil?
      return Kernel.load(file) if File.exist?(file)

      download(file)
    end

    private

    attr_reader :settings

    def download(url)
      Net::Hippie.logger = logger

      response = Net::Hippie::Client.new.yield_self do |x|
        x.with_retry { |y| y.get(url) }
      end
      path = Tempfile.new('del').path
      IO.write(path, response.body)
      load(path)
    end
  end
end
