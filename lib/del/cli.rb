require "del"
require "pathname"
require "thor"

module Del
  class CLI < Thor
    DEFAULT_RC=Pathname.new(Dir.home).join(".delrc")
    class_option :configuration_file, default: ENV.fetch("DELRC", DEFAULT_RC)
    class_option :socket_file, default: Del::Configuration::SOCKET_FILE

    desc "server <routes.rb>", "start server"
    def server(startup_file = nil)
      Del.start(
        configuration_file: options[:configuration_file],
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

    desc "setup", "setup your $HOME/.delrc"
    def setup
      settings = {}
      settings[:host] = ask("Where is your xmpp server? (E.g. 'chat.hipchat.com')")
      settings[:jid] = ask("What is your jabber Id?")
      settings[:muc_domain] = ask("What is your MUC domain? (E.g. 'conf.hipchat.com')")
      settings[:full_name] = ask("What is your name?")
      settings[:password] = ask("What is your password?", echo: false)

      say ""
      say "Writing your configuration to: #{options[:configuration_file]}", :green
      yaml = YAML.dump(settings)
      IO.write(options[:configuration_file], yaml)
      File.chmod(0600, options[:configuration_file])
    end

    desc "version", "Print the version of this gem"
    def version
      say Del::VERSION, :green
    end
  end
end
