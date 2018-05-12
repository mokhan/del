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
      settings = YAML.safe_load(IO.read(options[:configuration_file]))
      settings[:log_level] = options[:log_level]
      settings[:socket_file] = options[:socket_file]
      settings[:start_server] = true
      settings[:startup_file] = startup_file

      Del.start(settings)
    rescue Errno::ENOENT => error
      say error.message, :red
      say "run 'del setup'", :yellow
    end

    desc 'console <config.rb>', 'start read-eval-print-loop'
    def console(startup_file = nil)
      require 'irb'

      settings = YAML.safe_load(IO.read(options[:configuration_file]))
      settings[:log_level] = options[:log_level]
      settings[:socket_file] = options[:socket_file]
      settings[:start_server] = false
      settings[:startup_file] = startup_file

      Del.start(settings)
      ARGV.clear
      IRB.start
    end

    desc 'message <jid> <message>', 'send a message to the Jabber ID'
    def message(jid, message)
      SendMessage.new(self).run(jid, message)
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
        host: ask("Where is your xmpp server? (E.g. 'chat.hipchat.com')"),
        jid: ask('What is your jabber Id?'),
        muc_domain: ask("What is your MUC domain? (E.g. 'conf.hipchat.com')"),
        full_name: ask('What is your name?'),
        password: ask('What is your password?', echo: false)
      }
    end
  end
end
