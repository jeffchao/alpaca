require "rubygems"
require "bundler/setup"

require "minitest/autorun"
require "minitest/pride"

require "rack/test"
require 'active_support'
require "alpaca"

class Minitest::Spec
  include Rack::Test::Methods

  def app
    Rack::Builder.new {
      use Rack::Alpaca
      run lambda { |env| [200, {}, ['foo']] }
    }.to_app
  end
end
