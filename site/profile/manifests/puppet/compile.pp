# class profile::puppet::compile
class profile::puppet::compile {

  @@haproxy::balancermember { "puppet_${::clientcert}":
    listening_service => 'puppet00',
    server_names      => $::facts['networking']['hostname'],
    ipaddresses       => $::facts['networking']['interfaces']['enp0s8']['ip'],
    ports             => '8140',
    options           => 'check',
  }

  @@haproxy::balancermember { "orchestrator_${::clientcert}":
    listening_service => 'orchestrator00',
    server_names      => $::facts['networking']['hostname'],
    ipaddresses       => $::facts['networking']['interfaces']['enp0s8']['ip'],
    ports             => '8142',
    options           => 'check',
  }
}