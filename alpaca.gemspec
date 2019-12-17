# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'rack/alpaca/version'

Gem::Specification.new do |s|
  s.name = 'alpaca'
  s.version = Rack::Alpaca::VERSION
  s.license = 'MIT'

  s.authors = ["Jeff Chao"]
  s.description = "A rack middleware for whitelisting and blacklisting IPs"
  s.email = "jeffchao@me.com"

  s.files = Dir.glob("{bin,lib}/**/*") + %w(Rakefile README.md)
  s.homepage = 'http://github.com/jeffchao/alpaca'
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.summary = %q{Whitelist and blacklist IPs}
  s.test_files = Dir.glob("spec/**/*")

  s.required_ruby_version = '>= 2.6.0'

  s.add_dependency 'rack'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'activesupport', '>= 3.0.0'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'rack-test'
end

