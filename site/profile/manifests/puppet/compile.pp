# class profile::puppet::compile
class profile::puppet::compile {
  include ::node_manager

  @@haproxy::balancermember { "puppet_${::certname}":
    listening_service => 'puppet00',
    server_names      => $::facts['networking']['hostname'],
    ipaddresses       => $::facts['networking']['ipaddress'],
    ports             => '8140',
    options           => 'check',
  }

  @@haproxy::balancermember { "orchestrator_${::certname}":
    listening_service => 'orchestrator00',
    server_names      => $::facts['networking']['hostname'],
    ipaddresses       => $::facts['networking']['ipaddress'],
    ports             => '8142',
    options           => 'check',
  }
}