# class profile::base::packages
class profile::base::packages {
  $packages = hiera("profile::base::packages::${::facts['os']['family'].downcase}")

  assert_type(Hash, $packages)

  $packages.each | String $package, Hash $attrs | {
    package { $package:
      ensure   => $attrs['ensure'],
      provider => $attrs['provider'],
    }
  }
}
