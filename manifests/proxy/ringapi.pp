class swift::proxy::ringapi() {
  concat::fragment { 'swift_ringapi':
    target  => '/etc/swift/proxy-server.conf',
    content => template('swift/ringapi.conf.erb'),
    order   => '90',
  }
}
