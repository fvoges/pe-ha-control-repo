# class role::puppet::mom
class role::puppet::mom {

  include ::profile::base
  include ::profile::puppet::compile
  include ::profile::puppet::mom

}