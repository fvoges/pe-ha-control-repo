# class profile::base
class profile::base {

  if $::facts['pe_server_version'] {
    $install_app = true
  } else {
    $install_app = false
  }

  class { '::pe_mco_shell_agent':
    install_app => $install_app,
  }
}
