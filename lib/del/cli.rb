require "del"
require "pathname"
require "thor"

module Del
  class CLI < Thor
    DEFAULT_RC=Pathname.new(Dir.home).join(".delrc")
    class_option :dotenv_file, default: ENV.fetch("DELRC", DEFAULT_RC)

    desc "server <routes.rb>", "start server"
    def server(startup_file = nil)
      Del.start(
        dotenv_file: options[:dotenv_file],
        startup_file: startup_file,
      )
    end
  end
end
