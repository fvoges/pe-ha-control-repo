# Profile profile::puppet::backup
class profile::puppet::backup {
  $destination = hiera('profile::puppet::backup::destination')

  include ::pe_databases::backup

  file { $destination:
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0750',
  }

  class { '::pe_backup':
    destination => $destination,
    prefix      => $::trusted['certname'],
    # include the database dumps fron pe_databases::backup too
    dirs_extra  => [ $pe_databases::backup::backup_directory, ],
  }
}