require "del"
require "pathname"
require "thor"

module Del
  class CLI < Thor
    DEFAULT_RC=Pathname.new(Dir.home).join(".delrc")
    class_option :dotenv_file, default: ENV.fetch("DELRC", DEFAULT_RC)
    class_option :socket_file, default: Del::Configuration::SOCKET_FILE

    desc "server <routes.rb>", "start server"
    def server(startup_file = nil)
      Del.start(
        dotenv_file: options[:dotenv_file],
        socket_file: options[:socket_file],
        startup_file: startup_file,
      )
    end

    desc "message <jid> <message>", "send a message to the Jabber ID"
    def message(jid, message)
      socket = UNIXSocket.new(options[:socket_file])
      socket.puts(JSON.generate(command: :send_message, jid: jid, message: message))
      say socket.readline, :green
    rescue EOFError => error
      say error.message, :red
    rescue Errno::ECONNREFUSED => error
      say error.message, :red
      say "You must start the del server first.", :yellow
    ensure
      socket&.close
    end

    desc "version", "Print the version of this gem"
    def version
      say Del::VERSION, :green
    end
  end
end
