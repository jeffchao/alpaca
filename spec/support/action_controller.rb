require_relative 'filters'

module ActionController
  class Metal
    attr_accessor :request, :response

    def process(action)
      send(action)
    end

    def render(*args)
      response.status = Rack::Utils.status_code(args.first[:status])
      response.body = [args.first[:text]]
      response
    end
  end

  class Base < Metal
    include Filters
  end
end

if defined?(ActionController::Base)
  ActionController::Base.instance_eval do
    include Alpaca::ControllerAdditions
  end
end
