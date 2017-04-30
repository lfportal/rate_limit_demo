# Rate Limit Demo

This Rails application is intended to be an example of applying rate limiting to requests.

## Installation

If you haven't already, install bundler:

`$ gem install bundler`

And then execute:

`$ bundle`

This application requires a connection to Redis. Ensure you have a local copy of Redis running (with default configuration) or provide a url via the environment variable `REDIS_URL`.

## Usage

Run the application using `rails s`

The root path is rate limited to 100 requests every hour defined in:

```ruby
# config/initializers/rack_throttler.rb
Rack::Throttler.throttle(pattern: %r{^/$}, method: 'get', limit: 100, period: 1.hour)
```

You can test this by running curl requests to the server:

`curl 'localhost:3000'`

## Testing

To run the tests, Redis needs to be running locally.

Run the test suite by running:

`bundle exec rake`

## Contributing

Bug reports, feature requests and pull requests are welcome. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

