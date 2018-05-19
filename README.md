# Del the funky robosapien

[![Build Status](https://travis-ci.org/mokhan/del.svg?branch=master)](https://travis-ci.org/mokhan/del)

Del is a CLI/library for proxying requests to an XMPP server. It
can be used to configure chat bots to respond to direct messages or
messages in a multi user chat (MUC) room.

[Del is a funky robosapien](https://www.delhiero.com/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'del'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install del

## Usage

Run the setup command.

    $ del setup

By default all configuration is stored in a yaml file in your $HOME
directory named `.delrc`. E.g. `~/.delrc`

The setup will ask you for your XMPP password. If you are uncomfortable
storing your password in the `.delrc` you may skip that prompt. If you
choose not to store your password in `.delrc` then Del will prompt you
for your password each time you interact with Del.

Start the chat server:

    $ del server

Start the server with a file containing custom chat routes:

    $ del server lib/del/examples/routes.rb

Start the server with a remote file:

    $ del server https://gist.githubusercontent.com/mokhan/15882e15908273f7880eaeaa336d12d9/raw/a54db41e7824315b63b3e4e88df5c2f74ce27e30/routes.rb

See [link](https://gist.githubusercontent.com/mokhan/15882e15908273f7880eaeaa336d12d9/raw/a54db41e7824315b63b3e4e88df5c2f74ce27e30/routes.rb) for content.

Once the server is started, you may use the client to issue different commands:

Send a message to another user:

    $ del message 1_79@chat.btf.hipchat.com "Hello, World!"

Change your status:

    $ del status busy "I am on a WebEx call"

Print your profile information:

    $ del whoami

Print the profile information of another user:

    $ del whois <jid>

Print all users:

    $ del users

Interact with Del using a REPL:

    $ del console
    irb(main):001:0> Del.bot.busy!("I am really, really busy!")
    irb(main):002:0> Del.bot.online!

See help for additional information:

    $ del help

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `bin/cibuild` to run the tests and linters.

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mokhan/del.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
