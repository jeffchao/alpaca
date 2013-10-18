require_relative 'spec_helper'

describe 'Rack::Alpaca' do
  it 'should permit localhost' do
    get '/', {}, 'REMOTE_ADDR' => '127.0.0.1'
    last_response.status.must_equal 200
    last_response.body.must_equal 'foo'
  end

  describe 'Whitelist' do
    before do
      @ips = ["0.0.0.1", "198.18.0.0/15", "::/128"].map { |ip| IPAddr.new(ip) }
    end

    it 'should have a whitelist' do
      Rack::Alpaca.whitelist.class.must_equal Hash
      Rack::Alpaca.whitelist.each { |ip, v| ip.class.must_equal IPAddr }
      Rack::Alpaca.whitelist.keys.must_equal @ips
    end

    it 'should permit IP addresses on the whitelist' do
      Rack::Alpaca.whitelist.each do |ip, v|
        get '/', {}, 'REMOTE_ADDR' => ip.to_s
        last_response.status.must_equal 200
        last_response.body.must_equal 'foo'
      end
    end

    describe 'an IP on whitelist and blacklist' do
      it 'should permit the IP address' do
        get '/', {}, 'REMOTE_ADDR' => '0.0.0.1'
        last_response.status.must_equal 200
        last_response.body.must_equal 'foo'
      end
    end
  end

  describe 'Blacklist' do
    before do
      @ips = ["0.0.0.1", "0.0.0.2", "2001:db8::/32"].map { |ip| IPAddr.new(ip) }
    end

    it 'should have a blacklist' do
      Rack::Alpaca.blacklist.class.must_equal Hash
      Rack::Alpaca.whitelist.each { |ip, v| ip.class.must_equal IPAddr }
      Rack::Alpaca.blacklist.keys.must_equal @ips
    end

    it 'should reject IP addresses on the blacklist' do
      Rack::Alpaca.blacklist.each do |ip, v|
        get '/', {}, 'REMOTE_ADDR' => ip.to_s
        unless Rack::Alpaca.whitelist.keys.include? ip
          last_response.status.must_equal 503
          last_response.body.must_equal "Request blocked\n"
        end
      end
    end

    describe 'an IP on whitelist and blacklist' do
      it 'should permit the IP address' do
        get '/', {}, 'REMOTE_ADDR' => '0.0.0.1'
        last_response.status.must_equal 200
        last_response.body.must_equal 'foo'
      end
    end
  end

  describe 'allow-by-default' do
    before do
      @ips = ["0.0.0.1", "198.18.0.0/15", "::/128"].map { |ip| IPAddr.new(ip) }
    end

    it 'should permit any IP address' do
      @ips.each do |ip|
        get '/', {}, 'REMOTE_ADDR' => ip.to_s
        last_response.status.must_equal 200
        last_response.body.must_equal 'foo'
      end
    end
  end
end
