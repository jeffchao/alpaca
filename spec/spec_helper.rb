require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

require "rubygems"
require "bundler/setup"

require "minitest/autorun"
require "minitest/pride"

require "rack/test"
require 'active_support'
require "alpaca"

require_relative 'support/action_controller'
require_relative 'support/foo_controller'
require_relative 'support/bar_controller'
require_relative 'support/baz_controller'

class Minitest::Spec
  include Rack::Test::Methods

  def app
    Rack::Builder.new {
      use Rack::Alpaca

      map '/foo' do
        run lambda { |env|
          controller = ::FooController.new
          controller.request = Rack::Request.new(env)
          controller.response = Rack::Response.new
          controller.process('foo')

          controller.response.finish
        }
      end

      map '/bar' do
        run lambda { |env|
          controller = ::BarController.new
          controller.request = Rack::Request.new(env)
          controller.response = Rack::Response.new
          controller.process('bar')

          controller.response.finish
        }
      end

      map '/baz' do
        run lambda { |env|
          controller = ::BazController.new
          controller.request = Rack::Request.new(env)
          controller.response = Rack::Response.new
          controller.process('baz')

          controller.response.finish
        }
      end

      run lambda { |env| [200, {}, ['foo']] }
    }.to_app
  end
end
