# Installs nsight
class nvidia::nsight (
  String $version              = 'latest',
  String $systems_package_name = 'nsight-systems-2024.6.2',
  String $compute_package_name = 'nsight-compute-2024.1.0',
){
  package { $systems_package_name:
    ensure => $version,
  }
  package { $compute_package_name:
    ensure => $version,
  }
}
