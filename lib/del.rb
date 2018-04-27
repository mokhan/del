require "dotenv"
require "xmpp4r"
require "xmpp4r/muc/helper/mucbrowser"
require "xmpp4r/muc/helper/simplemucclient"
require "xmpp4r/roster/helper/roster"

require "del/robot"
require "del/version"
require "del/room_repository"
require "del/user"
require "del/user_repository"

module Del
  def self.start
    Dotenv.load(".env.local", Pathname.new(Dir.home).join(".delrc").to_s)

    del = Robot.new(configuration: {
      host: ENV["DEL_HOST"],
      jid: ENV["DEL_JID"],
      muc_domain: ENV["DEL_MUC_DOMAIN"],
      password: ENV["DEL_PASSWORD"],
    })
    del.run
  end
end
