require "dotenv"
require "json"
require "logger"
require "socket"
require "xmpp4r"
require "xmpp4r/muc/helper/mucbrowser"
require "xmpp4r/muc/helper/simplemucclient"
require "xmpp4r/roster/helper/roster"

require "del/configuration"
require "del/connection"
require "del/default_router"
require "del/message"
require "del/repository"
require "del/robot"
require "del/socket_connection"
require "del/socket_server"
require "del/source"
require "del/user"
require "del/version"

module Del
  def self.start(dotenv_file:, startup_file: nil, start_server: true, socket_file: nil)
    puts "Loading... #{dotenv_file}"
    Dotenv.load(dotenv_file.to_s)
    Del.configure do |config|
      config.socket_file = socket_file if socket_file
      config.router.register(/.*/) do |message|
        logger.debug(message.to_s)
      end
    end
    load startup_file if startup_file && File.exist?(startup_file)

    del = Robot.new(configuration: configuration)
    del.get_funky!(start_server: start_server)
  end

  def self.configure
    yield configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.logger
    @logger ||= configuration.logger
  end
end
