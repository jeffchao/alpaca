## Alpaca (outta nowhere)

[![Gem Version](https://badge.fury.io/rb/alpaca.png)](http://badge.fury.io/rb/alpaca)
[![Build Status](https://travis-ci.org/jeffchao/alpaca.png?branch=master)](https://travis-ci.org/jeffchao/alpaca)
[![Dependency Status](https://gemnasium.com/jeffchao/alpaca.png)](https://gemnasium.com/jeffchao/alpaca)
[![Coverage Status](https://coveralls.io/repos/jeffchao/alpaca/badge.png)](https://coveralls.io/r/jeffchao/alpaca)

Alpaca (outta nowhere) is a rack middleware that allows developers to quickly and easily configure and manage a whitelist and/or blacklist. The motivation for Alpaca is to address use cases around security concerns such as malicious clients, denial of service, or adding an extra layer of security to an API or a subset of API endpoints.

![Alpaca](https://raw.github.com/jeffchao/alpaca/master/alpaca.jpeg)

Features
----------

- Global-level whitelisting and blacklisting at the rack layer
- Controller-level whitelisting and blacklisting via `before_filter`
- Per-action whitelisting and blacklisting at the controller level
- Configuration management via YAML

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
- hostnames (e.g., `127.0.0.1` also affects `localhost`)
- range of IP addresses via subnet masks (e.g., `198.18.0.0/15`, `2001:db8::/32`).

### Global-level whitelisting and blacklisting

You may use IPv4 or IPv6. Make changes in `config/alpaca.yml` by adding or removing IPs to and from either list. Your file should resemble the following:

```yaml
whitelist:
  - 0.0.0.1
  - 198.18.0.0/15
  - "::/128"
blacklist:
  - 0.0.0.1
  - 0.0.0.2
  - "2001:db8::/32"
default: allow
```

Depending on your strategy, you may choose to enforce an allow-by-default or deny-by-default approach. You can use the `default` key in the configuration file with either `allow` or `deny` as its value.

**A note about precedence**: If an IP exists in both the whitelist and blacklist, then whitelist will take precedence and allow the IP.

### Controller-level whitelisting and blacklisting

There exists two methods for handling IPs at the controller level. You must have your global-level default set to `allow` for it to be useful. This is because a global-level `deny` would have already blocked all IPs at the rack layer.

```ruby
before_filter :enable_whitelist_and_deny_by_default

# or

before_filter :enable_blacklist_and_allow_by_default
```

You may optionally attach this filter to specific method(s):

```ruby
before_filter :enable_whitlist_and_deny_by_default, only: [:create, :update]
```

Lastly, you may add additional IPs that were not previously defined in your alpaca.yml`:

```ruby
before_filter only: [:create, :update] { |f| f.enable_whitelist_and_deny_by_default(['0.0.0.1']) }
```

### Example setups

Given that some configuration permuations may be unecessary or illogical, the following is a table of typical use cases. The cells represent the resulting behavior:

|     | global allow-by-default | global deny-by-default |
| --- | ----------------------- | ---------------------- |
| **no controller filter** | all IPs allowed | all IPs denied |
| **controller filter whitelist, no added IPs** | IPs in whitelist from `alpaca.yml` allowed for controller. All other IPs denied for controller. All IPs allowed everywhere else | all IPs denied |
| **controller filter whitelist, added IPs** | IPs in whitelist from `alpaca.yml` and arguments to filter allowed for controller. All other IPs denied for controller. All IPs allowed everywhere else | all IPs denied |
| **controller filter blacklist, no added IPs** | IPs in blacklist from `alpaca.yml` denied for controller. All other IPs allowed for controller. All IPs allowed everywhere else | all IPs denied |
| **controller filter blacklist, added IPs** | IPs in blacklist from `alpaca.yml` and arguments denied for controller. All other IPs allowed for controller. All IPs allowed everywhere else | all IPs denied |

Performance
----------

Through initial testing, Alpaca does not appear to cause noticeable overhead. Future tests under different types of load will be documented here.

Author
----------

Jeff Chao, @thejeffchao, http://thejeffchao.com
