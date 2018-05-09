require "del"
require "pathname"
require "thor"

module Del
  class CLI < Thor
    DEFAULT_RC=Pathname.new(Dir.home).join(".delrc")
    class_option :configuration_file, default: ENV.fetch("DELRC", DEFAULT_RC)
    class_option :socket_file, default: Del::Configuration::SOCKET_FILE
    class_option :log_level, default: ENV.fetch("LOG_LEVEL", Logger::INFO).to_i

    desc "server <routes.rb>", "start server"
    def server(startup_file = nil)
      settings = YAML.load(IO.read(options[:configuration_file]))
      settings.merge!(log_level: options[:log_level])
      settings.merge!(socket_file: options[:socket_file])
      settings.merge!(start_server: true)
      settings.merge!(startup_file: startup_file)

      Del.start(settings)
    rescue Errno::ENOENT => error
      say error.message, :red
      say "run 'del setup'", :yellow
    end

    desc "console <config.rb>", "start read-eval-print-loop"
    def console(startup_file = nil)
      require "irb"

      settings = YAML.load(IO.read(options[:configuration_file]))
      settings.merge!(log_level: options[:log_level])
      settings.merge!(socket_file: options[:socket_file])
      settings.merge!(start_server: false)
      settings.merge!(startup_file: startup_file)

      Del.start(settings)
      ARGV.clear
      IRB.start
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
      settings = {
        host: ask("Where is your xmpp server? (E.g. 'chat.hipchat.com')"),
        jid: ask("What is your jabber Id?"),
        muc_domain: ask("What is your MUC domain? (E.g. 'conf.hipchat.com')"),
        full_name: ask("What is your name?"),
        password: ask("What is your password?", echo: false),
      }

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
