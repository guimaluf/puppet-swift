require 'spec_helper'

describe 'swift::proxy::informant' do

  let :facts do
    {}
  end

  let :pre_condition do
    'class { "concat::setup": }
     concat { "/etc/swift/proxy-server.conf": }'
  end

  let :fragment_file do
    "/var/lib/puppet/concat/_etc_swift_proxy-server.conf/fragments/19_swift-proxy-informant"
  end

  it { is_expected.to contain_file(fragment_file).with_content(/[filter:informant]/) }
  it { is_expected.to contain_file(fragment_file).with_content(/use = egg:swift#informant/) }

  [
    'statsd_host',
    'statsd_port',
    'statsd_sample_rate',
    'valid_http_methods',
    'combined_events',
    'combine_key',
    'metric_name_prepend',
    'prefix_accounts',
  ].each do |h|
    it { is_expected.to_not contain_file(fragment_file).with_content(/#{h}/) }
  end

  context "when params are set" do
    let :params do {
      'statsd_host'         => '127.0.0.1',
      'statsd_port'         => '8125',
      'statsd_sample_rate'  => '0.5',
      'valid_http_methods'  => ['GET','HEAD','POST','PUT','DELETE','COPY'],
      'combined_events'     => 'no',
      'combine_key'         => '\n',
      'metric_name_prepend' => 'myhost',
      'prefix_accounts'     => 'AUTH_test',
    } end

    it { is_expected.to contain_file(fragment_file).with_content(/valid_http_methods = GET,HEAD,POST,PUT,DELETE,COPY/) }
    it { is_expected.to contain_file(fragment_file).with_content(/statsd_host = 127.0.0.1/)}
    it { is_expected.to contain_file(fragment_file).with_content(/statsd_port = 8125/)}
    it { is_expected.to contain_file(fragment_file).with_content(/statsd_sample_rate = 0.5/)}
    it { is_expected.to contain_file(fragment_file).with_content(/combined_events = no/)}
    it { is_expected.to contain_file(fragment_file).with_content(/combine_key = \\n/)}
    it { is_expected.to contain_file(fragment_file).with_content(/metric_name_prepend = myhost/)}
    it { is_expected.to contain_file(fragment_file).with_content(/prefix_accounts = AUTH_test/)}

    describe 'when params are not array' do
      let :params do {
        'valid_http_methods' => 'GET,HEAD,POST,PUT,DELETE,COPY'
      } end

      it { is_expected.to contain_file(fragment_file).with_content(/valid_http_methods = GET,HEAD,POST,PUT,DELETE,COPY/) }
    end
  end
end
