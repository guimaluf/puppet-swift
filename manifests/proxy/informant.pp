#
# Configure swift informant. But doesn't install the middleware
# The defaults values are set by the middleware.
#
# == Parameters
#
#  [*statsd_host*]
#    Statsd server address.
#    Optional. Defaults to undef. Example: 127.0.0.1
#
#  [*statsd_port*]
#    Statsd server port.
#    Optional. Defaults to undef. Example: 8125
#
#  [*statsd_sample_rate*]
#    Standard statsd sample rate 0.0 <= 1
#    Optional. Defaults to undef. Example: 0.5
#
#  [*valid_http_methods*]
#    List of allowed methods, all others will generate a "BAD_METHOD" event
#    Optional. Defaults to undef.
#    Example: ['GET','HEAD','PUT','POST','DELETE','COPY'] or 'GET,HEAD,PUT,POST,DELETE,COPY'
#
#  [*combined_events*]
#    Send multiple statsd events per packet as supported by statsdpy
#    Optional. Defaults to undef. Example: 'no'
#
#  [*combine_key*]
#    They key used to combine events for reporting to statsd, alternate
#    versions used a # to seperate events. The offical way is by newline
#    Optional. Defaults to undef. Example: '\n'
#
#  [*metric_name_prepend*]
#    Prepends name to metric collection output for easier recognition
#    Optional. Defaults to undef. Example = 'company.swift'
#
#  [*prefix_accounts*]
#    A list of accounts for who we'll account prefix the metric name with their
#    account name. This lets you track metrics for specific accounts independently.
#    Optional. Defaults to undef. Example: 'AUTH_something'
#
# == Examples
#
#  class {'swift::proxy::informant':
#    statsd_host => 'monitor.myhost.com',
#    metric_name_prepend => $::hostname,
#  }
#
# == Authors
#
#   Guilherme Maluf Balzana <guimalufb@gmail.com>
#
# == Copyright
#
# Copyright 2015 Guilherme Maluf Balzana
#
class swift::proxy::informant (
  $statsd_host            = undef,
  $statsd_port            = undef,
  $statsd_sample_rate     = undef,
  $valid_http_methods     = undef,
  $combined_events        = undef,
  $combine_key            = undef,
  $metric_name_prepend    = undef,
  $prefix_accounts        = undef,
) {

  if($valid_http_methods) {
    if is_array($valid_http_methods) {
      $valid_http_methods_real = join($valid_http_methods,',')
    } elsif is_string($valid_http_methods) {
      $valid_http_methods_real = $valid_http_methods
    }
  }

  if ($statsd_host) {
    validate_string($statd_host)
  }

  if ($statsd_port){
    validate_integer($statsd_port)
  }

  if ($combined_events) {
    validate_re($combined_events,['yes','no'])
  }

  if ($combine_key) {
    validate_string($combine_key)
  }

  if ($metric_name_prepend) {
    validate_string($metric_name_prepend)
  }

  if ($prefix_accounts) {
    validate_string($prefix_accounts)
  }

  concat::fragment { 'swift-proxy-informant':
    target  => '/etc/swift/proxy-server.conf',
    content => template('swift/proxy/informant.conf.erb'),
    order   => '19',
  }
}

