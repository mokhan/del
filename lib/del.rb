require "json"
require "logger"
require "net/hippie"
require "open3"
require "socket"
require "xmpp4r"
require "xmpp4r/muc/helper/mucbrowser"
require "xmpp4r/muc/helper/simplemucclient"
require "xmpp4r/roster/helper/roster"
require "yaml"

require "del/configuration"
require "del/connection"
require "del/default_router"
require "del/message"
require "del/repository"
require "del/robot"
require "del/shell_command"
require "del/socket_connection"
require "del/socket_server"
require "del/source"
require "del/user"
require "del/version"

module Del
  def self.start(settings)
    @configuration = Configuration.new(settings)
    @configuration.router.register(/.*/) do |message|
      logger.debug(message.to_s)
    end
    @configuration.load(settings[:startup_file])
    bot.get_funky!(start_server: settings[:start_server])
  end

  def self.configure
    yield configuration
  end

  def self.configuration
    @configuration ||= Configuration.new({})
  end

  def self.logger
    @logger ||= configuration.logger
  end

  def self.bot
    @bot ||= Robot.new(configuration: configuration)
  end
end
