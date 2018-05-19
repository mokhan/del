# frozen_string_literal: true

require 'json'
require 'logger'
require 'net/hippie'
require 'open3'
require 'socket'
require 'tempfile'
require 'xmpp4r'
require 'xmpp4r/muc/helper/mucbrowser'
require 'xmpp4r/muc/helper/simplemucclient'
require 'xmpp4r/roster/helper/roster'
require 'yaml'

require 'del/configuration'
require 'del/default_router'
require 'del/message'
require 'del/repository'
require 'del/robot'
require 'del/send_message'
require 'del/shell_command'
require 'del/socket_connection'
require 'del/socket_message'
require 'del/socket_server'
require 'del/source'
require 'del/tron'
require 'del/user'
require 'del/version'
require 'del/xmpp_connection'

# Del the funky robosapien.
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
