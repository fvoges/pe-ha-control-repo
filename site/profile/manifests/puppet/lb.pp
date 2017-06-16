# class profile::puppet::lb
class profile::puppet::lb {

  class { '::haproxy': }

  haproxy::listen { 'puppet00':
    ipaddress => $::facts['networking']['interfaces']['eth1']['ip'],
    ports     => '8140',
    options   => {
      'balance' => 'leastconn',
    },
  }

  haproxy::listen { 'orchestrator00':
    ipaddress => $::facts['networking']['interfaces']['eth1']['ip'],
    ports     => '8142',
    options   => {
      'balance'        => 'leastconn',
      'timeout tunnel' => '15m',
    },
  }

}