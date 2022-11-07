# Installs nsight
class nvidia::nsight (
  $version = 'latest',
  $package_name = 'nsight-systems-2022.4.2', ){
  package { $package_name:
    ensure => $version,
  }
}
