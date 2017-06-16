# class profile::base
class profile::base {
  $packages = hiera("profile::base::packages_${::facts['os']['family'].downcase}")

  assert_type(Hash, $packages)

  # We only want to install the mco app on the Puppet Masters
  $install_app = $::facts['pe_server_version'] ? {
    undef   => false,
    default => true,
  }

  $datacentre = $::facts['networking']['hostname'] ? {
    /01/    => 'dc01',
    /02/    => 'dc02',
    default => 'unknown',
  }

  $packages.each | String $package, Hash $attrs | {
    package { $package:
      ensure   => $attrs['ensure'],
      provider => $attrs['provider'],
    }
  }

  class { '::pe_mco_shell_agent':
    install_app => $install_app,
  }

  file { ['/etc/puppetlabs/facter', '/etc/puppetlabs/facter/facts.d']:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/etc/puppetlabs/facter/facts.d/org_datacentre.txt':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "org_datacentre=${datacentre}\n",
  }
}
