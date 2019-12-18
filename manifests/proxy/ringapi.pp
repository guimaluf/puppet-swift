class swift::proxy::ringapi() {
  concat::fragment { 'swift_ringapi':
    target  => '/etc/swift/proxy-server.conf',
    content => template('swift/proxy/ringapi.conf.erb'),
    order   => '90',
  }
}
