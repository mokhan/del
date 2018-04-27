require "del/robot"
require "del/version"
require 'dotenv'

module Del
  def self.start
    Dotenv.load(".env.local", Pathname.new(Dir.home).join(".delrc").to_s)

    del = Robot.new(configuration: {
      host: ENV['DEL_HOST'],
      jid: ENV['DEL_JID'],
      muc_domain: ENV['DEL_MUC_DOMAIN'],
      password: ENV['DEL_PASSWORD'],
    })
    del.run
  end
end
