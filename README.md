## Alpaca (outta nowhere)

[![Build Status](https://travis-ci.org/jeffchao/alpaca.png?branch=master)](https://travis-ci.org/jeffchao/alpaca)

Alpaca (outta nowhere) is a rack middleware that allows developers to quickly and easily configure and manage a whitelist and/or blacklist. The motivation for Alpaca is to address use cases around security concerns such as malicious clients, denial of service, or adding an extra layer of security to an API or a subset of API endpoints.

![Alpaca](https://raw.github.com/jeffchao/alpaca/master/alpaca.jpeg)

Getting started
----------

Install standalone or add to your Gemfile:

```ruby
gem 'alpaca'
```

Run `bundle install` to install the gem.

Afer you install Alpaca, run the generator to create a default config file:

```ruby
rails generate alpaca:install
```

Add Alpaca to your middleware stack in `config/application.rb`:

```ruby
config.middleware.use Rack::Alpaca
```

or if you are not using rails, but in another Rack application, in `config.ru`:

```ruby
use Rack::Alpaca
```

Usage
----------

Alpaca supports:

- whitelisting and blacklisting single IP addresses (e.g., `0.0.0.1`)
- hostnames (e.g., `localhost`)
- range of IP addresses with subnet masks (e.g., `198.18.0.0/15`, `2001:db8::/32`).

You may use IPv4 or IPv6. You can make changes in `config/alpaca.yml` to either list.

Depending on your strategy, you may choose to enforce a whitelist-by-default or blacklist-by-default approach. You can use the `default` key in the configuration file with either `whitelist` or `blacklist` as its value.

Performance (WIP)
----------

Through initial testing, Alpaca does not appear to cause noticeable overhead. Future tests under different types of load will be documented here.

In progress
----------

- ~~Global-level whitelist and blacklist~~
- ~~Configuration and management via YAML~~
- ~~Whitelist-by-default, blacklist-by-default~~
- Controller-level whitelist and blacklist via `before_filter`

Author
----------

Jeff Chao, @thejeffchao, http://thejeffchao.com
