# class profile::puppet::lb
class profile::puppet::lb {

  class { '::haproxy': }

  haproxy::listen { 'puppet00':
    ipaddress => $::facts['networking']['ipaddress'],
    ports     => '8140',
    options   => [
      'leastconn',
    ],
  }

  haproxy::listen { 'orchestrator00':
    ipaddress => $::facts['networking']['ipaddress'],
    ports     => '8142',
    options   => [
      'leastconn',
      'timeout tunnel 15m',
    ],
  }

}