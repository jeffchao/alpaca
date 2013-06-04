module Alpaca
  # These are additional helper methods that are added to
  # ApplicationController. In particular, this module contains
  # filters that should be used as before_filters.
  module ControllerAdditions
    def enable_whitelist_and_deny_by_default (additional_ips = [])
      render_blocked_request unless whitelisted?(additional_ips)
    end

    def enable_blacklist_and_allow_by_default (additional_ips = [])
      if blacklisted?(additional_ips)
        render_blocked_request
      end
    end

    private

    def whitelisted? (additional_ips)
      additional_ips.any? { |ip| IPAddr.new(ip).include?(request.ip) } ||
        Rack::Alpaca.whitelist.any? { |ip| ip.include?(request.ip) }
    end

    def blacklisted? (additional_ips)
      additional_ips.any? { |ip| IPAddr.new(ip).include?(request.ip) } ||
        Rack::Alpaca.blacklist.any? { |ip| ip.include?(request.ip) }
    end

    def render_blocked_request
      render text: "Request blocked\n",
             status: :service_unavailable,
             content_type: 'text/plain'
    end
  end
end

if defined?(ActionController::Base)
  ActionController::Base.instance_eval do
    include Alpaca::ControllerAdditions
  end
end
