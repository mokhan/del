require "dotenv"
require "logger"
require "xmpp4r"
require "xmpp4r/muc/helper/mucbrowser"
require "xmpp4r/muc/helper/simplemucclient"
require "xmpp4r/roster/helper/roster"

require "del/connection"
require "del/default_router"
require "del/robot"
require "del/repository"
require "del/version"

module Del
  def self.start(dotenv_file:)
    puts "Loading... #{dotenv_file}"
    Dotenv.load(dotenv_file.to_s)
    puts "It's fire! 🔥"
    del = Robot.new(configuration: configuration)
    del.get_funky!
  end

  def self.configure
    yield configuration
  end

  def self.configuration
    @configuration ||= {
      default_rooms: ENV.fetch("DEL_ROOMS", '').split(','),
      host: ENV.fetch("DEL_HOST"),
      jid: ENV.fetch("DEL_JID"),
      logger: Logger.new(STDOUT),
      muc_domain: ENV.fetch("DEL_MUC_DOMAIN"),
      name: ENV.fetch("DEL_FULL_NAME"),
      password: ENV.fetch("DEL_PASSWORD"),
      rooms: Repository.new,
      router: DefaultRouter.new,
      users: Repository.new,
    }
  end

  def self.logger
    @logger ||= configuration[:logger]
  end
end
