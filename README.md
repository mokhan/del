# Del

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

Create a `.delrc` file in your `$HOME` directory.

Add the following environment variables:

```text
DEL_FULL_NAME='Del the Funky Robosapien'
DEL_HOST='chat.mycompany.com'
DEL_JID='my_id@chat.btf.hipchat.com'
DEL_MUC_DOMAIN='conf.btf.hipchat.com'
DEL_PASSWORD=secret
DEL_ROOMS=1_pidge,2_hunk,3_shiro
```

Start the chat server:

    $ del server

Start the server with a file containing custom chat routes:

    $ del server lib/del/examples/routes.rb

Start the server with a remote file:

    $ del server https://gist.githubusercontent.com/mokhan/15882e15908273f7880eaeaa336d12d9/raw/a54db41e7824315b63b3e4e88df5c2f74ce27e30/routes.rb

Once the server is started, you may use the client to send messages
through it.

    $ del message 1_79@chat.btf.hipchat.com "Hello, World!"

See the help for additional information:

    $ del help

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mokhan/del.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
