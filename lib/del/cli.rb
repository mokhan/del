# frozen_string_literal: true

require 'del'
require 'pathname'
require 'thor'

module Del
  class CLI < Thor
    DEFAULT_RC = Pathname.new(Dir.home).join('.delrc')
    class_option :configuration_file, default: ENV.fetch('DELRC', DEFAULT_RC)
    class_option :socket_file, default: Del::Configuration::SOCKET_FILE
    class_option :log_level, default: ENV.fetch('LOG_LEVEL', Logger::INFO).to_i

    desc 'server <routes.rb>', 'start server'
    def server(startup_file = nil)
      Del.start(load_settings(start_server: true, startup_file: startup_file))
    rescue Errno::ENOENT => error
      say error.message, :red
      say "run 'del setup'", :yellow
    end

    desc 'console <config.rb>', 'start read-eval-print-loop'
    def console(startup_file = nil)
      require 'irb'

      Del.start(load_settings(start_server: false, startup_file: startup_file))
      ARGV.clear
      IRB.start
    rescue Errno::ENOENT => error
      say error.message, :red
      say "run 'del setup'", :yellow
    end

    desc 'message <jid> <message>', 'send a message to the Jabber ID'
    def message(jid, message)
      SendMessage.new(
        self,
        socket_file: options[:socket_file]
      ).run(jid, message)
    end

    desc 'whoami', 'send a whoami message to the local del server'
    def whoami
      socket = SocketMessage.new(self, socket_file: options[:socket_file])
      socket.deliver(command: :whoami)
      say(socket.listen, :green)
    ensure
      socket.close
    end

    desc 'whois <jid>', 'whois a specific user'
    def whois(jid)
      socket = SocketMessage.new(self, socket_file: options[:socket_file])
      socket.deliver(command: :whois, q: jid)
      say(socket.listen, :green)
    ensure
      socket.close
    end

    desc 'users', 'list all users'
    def users
      socket = SocketMessage.new(self, socket_file: options[:socket_file])
      socket.deliver(command: :users)
      say(socket.listen, :green)
    ensure
      socket.close
    end

    desc 'setup', 'setup your $HOME/.delrc'
    def setup
      yaml = YAML.dump(new_settings)
      IO.write(options[:configuration_file], yaml)
      File.chmod(0o600, options[:configuration_file])
      say ''
      say "Configuration saved to: #{options[:configuration_file]}", :green
    end

    desc 'version', 'Print the version of this gem'
    def version
      say Del::VERSION, :green
    end

    private

    def new_settings
      {
        'host' => ask("XMPP server: (E.g. 'chat.hipchat.com')"),
        'jid' => ask('Jabber Id:'),
        'muc_domain' => ask("MUC domain: (E.g. 'conf.hipchat.com')"),
        'full_name' => ask('Name:'),
        'password' => ask('Password:', echo: false)
      }
    end

    def load_settings(additional_settings)
      settings = YAML.safe_load(
        IO.read(options[:configuration_file]),
        symbolize_names: true
      )
      if settings[:password].nil? || settings[:password].length.zero?
        settings[:password] = ask('Password:', echo: false)
      end
      settings[:log_level] = options[:log_level]
      settings[:socket_file] = options[:socket_file]
      settings.merge(additional_settings)
    end
  end
end
