Del.configure do |config|
  puts "Registering custom routes."

  config.router.register(/.*/) do |message|
    message.reply(message.text.reverse)
  end
end
