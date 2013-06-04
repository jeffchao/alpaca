require_relative 'spec_helper'

describe 'Alpaca::ControllerAdditions' do
  before do
    @ips = ["0.0.0.1", "198.18.0.0/15", "0.0.0.3"].map { |ip| IPAddr.new(ip) }
  end

  it 'should initialize with controller additions' do
    controller = FooController.new
    controller.methods.must_include(:enable_whitelist_and_deny_by_default)
    controller.methods.must_include(:enable_blacklist_and_allow_by_default)
  end

  describe 'with global allow-by-default' do
    describe '#enable_whitelist_and_deny_by_default' do
      it 'should only permit IPs on the whitelist' do
        @ips[0...-1].each do |ip|
          get '/', {}, 'REMOTE_ADDR' => ip.to_s
          last_response.status.must_equal 200
          last_response.body.must_equal 'foo'
        end

        get '/foo', {}, 'REMOTE_ADDR' => @ips.last.to_s
        last_response.status.must_equal 503
        last_response.body.must_equal "Request blocked\n"
      end

      describe 'with additional IPs' do
        it 'should permit IPs on the whitelist and arguments' do
          @ips = @ips[0...-1].push('0.0.0.4')
          @ips[0..-1].each do |ip|
            get '/baz', {}, 'REMOTE_ADDR' => ip.to_s
            last_response.status.must_equal 200
            last_response.body.must_equal 'baz'
          end
        end
      end
    end

    describe '#enable_blacklist_and_allow_by_default' do
      it 'should allow all IPs except ones on the blacklist' do
        @ips[1..-1].each do |ip|
          get '/', {}, 'REMOTE_ADDR' => ip.to_s
          last_response.status.must_equal 200
          last_response.body.must_equal 'foo'
        end

        get '/bar', {}, 'REMOTE_ADDR' => @ips.first.to_s
        last_response.status.must_equal 503
        last_response.body.must_equal "Request blocked\n"
      end
    end
  end
end
