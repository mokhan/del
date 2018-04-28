require "dotenv"
require "logger"
require "xmpp4r"
require "xmpp4r/muc/helper/mucbrowser"
require "xmpp4r/muc/helper/simplemucclient"
require "xmpp4r/roster/helper/roster"

require "del/connection"
require "del/configuration"
require "del/default_router"
require "del/message"
require "del/repository"
require "del/robot"
require "del/source"
require "del/user"
require "del/version"

module Del
  def self.start(dotenv_file:, startup_file:)
    puts "Loading... #{dotenv_file}"
    Dotenv.load(dotenv_file.to_s)
    Del.configure do |config|
      config.router.register(/.*/) do |message|
        logger.debug(message.to_s)
      end
    end
    load startup_file if startup_file && File.exist?(startup_file)

    del = Robot.new(configuration: configuration)
    del.get_funky!
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
