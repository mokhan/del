Del.configure do |config|
  puts "Registering custom routes."

  config.router.register(/.*/) do |message|
    Del.logger.info("Backwards!")
    message.reply(message.text.reverse)
  end

  config.router.register(/^cowsay (.*)/) do |message, match_data|
    Del.logger.info("COWSAY!")
    message.reply("/code #{`cowsay #{match_data[1]}`}")
  end

  config.router.register(/^[Hh]ello/) do |message|
    message.reply("Hi!")
  end
end
