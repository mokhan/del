require "dotenv"
require "logger"
require "xmpp4r"
require "xmpp4r/muc/helper/mucbrowser"
require "xmpp4r/muc/helper/simplemucclient"
require "xmpp4r/roster/helper/roster"

require "del/connection"
require "del/default_router"
require "del/robot"
require "del/room_repository"
require "del/user"
require "del/user_repository"
require "del/version"

module Del
  def self.start(dotenv_file:)
    puts "Loading... #{dotenv_file}"
    Dotenv.load(dotenv_file)
    puts "It's fire! 🔥"
    del = Robot.new(configuration: configuration)
    del.get_funky!
  end

  def self.configure
    yield configuration
  end

  def self.configuration
    @configuration ||= {
      host: ENV.fetch("DEL_HOST"),
      jid: ENV.fetch("DEL_JID"),
      muc_domain: ENV.fetch("DEL_MUC_DOMAIN"),
      password: ENV.fetch("DEL_PASSWORD"),
      router: DefaultRouter.new,
      logger: Logger.new(STDOUT)
    }
  end

  def self.logger
    @logger ||= configuration[:logger]
  end
end
