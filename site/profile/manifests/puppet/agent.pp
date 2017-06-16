# class profile::puppet::agent
class profile::puppet::agent {

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
  ini_setting { 'puppet.conf:main:archive_file_server':
    ensure  => absent,
    path    => $::settings::config,
    section => 'main',
    setting => 'archive_file_server',
  }

  ini_setting { 'puppet.conf:main:archive_files':
    ensure  => absent,
    path    => $::settings::config,
    section => 'main',
    setting => 'archive_files',
  }
}