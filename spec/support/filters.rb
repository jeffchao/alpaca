module Filters
  def self.included (base)
    base.extend ClassMethods
  end

  module ClassMethods
    def before_filters
      @before_filters ||= []
    end

    def before_filter(*args)
      method = args.shift
      ips = args.shift
      before_filters << (ips.nil? ? [method] : [method, ips])
    end
  end

  def process(action)
    self.class.before_filters.each { |method, ips| ips.nil? ? send(method) : send(method, ips) }
    super
  end
end
