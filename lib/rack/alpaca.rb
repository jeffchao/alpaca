module Rack
  module Alpaca
    class << self

      attr_reader :whitelist, :blacklist
      attr_accessor :default

      def new (app)
        @@config ||= YAML.load_file('config/alpaca.yml')

        @app = app
        @whitelist ||= Hash[@@config['whitelist'].map { |ip| [IPAddr.new(ip), true] }].freeze
        @blacklist ||= Hash[@@config['blacklist'].map { |ip| [IPAddr.new(ip), true] }].freeze
        @default = @@config['default']

        self
      end

      def call (env)
        req = Rack::Request.new(env)

        if whitelisted?('whitelist', req)
          @app.call(env)
        elsif blacklisted?('blacklist', req)
          [503, {}, ["Request blocked\n"]]
        else
          default_strategy(env)
        end
      end

      private

      def default_strategy (env)
        if @default == 'allow'
          @app.call(env)
        elsif @default == 'deny'
          [503, {}, ["Request blocked\n"]]
        else
          raise 'Unknown default strategy'
        end
      end

      def check (type, req)
        req_ip = IPAddr.new(req.ip)
        !instance_variable_get("@#{type}").select { |k, v| k.include? req_ip }.empty?
        #instance_variable_get("@#{type}")[req_ip]
        #instance_variable_get("@#{type}").any? do |ip|
        #  ip.include?(req.ip)
        #end
      end

      alias_method :whitelisted?, :check
      alias_method :blacklisted?, :check
    end
  end
end
