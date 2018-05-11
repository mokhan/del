Del.configure do |x|
  puts 'Registering custom routes.'

  x.router.register(/.*/) do |message|
    Del.logger.info('Backwards!')
    message.reply(message.text.reverse)
  end

  x.router.register(/^cowsay (.*)/) do |message, match_data|
    Del.logger.info('COWSAY!')
    message.execute_shell(['cowsay', match_data[1]])
  end

  x.router.register(/^[Hh]ello/) do |message|
    message.reply('Hi!')
  end
end
