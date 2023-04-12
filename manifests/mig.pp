# Configures mig and starts service
class nvidia::mig (
  $version    = 'installed',
  $mig_config = 'all-1g.5gb',
){
  package { 'nvidia-mig-manager':
    ensure => $version,
  }

  file { '/etc/systemd/system/nvidia-mig-manager.service.d/override.conf' :
    content => template('nvidia/mig-override.conf.erb'),
    owner   => 'root',
    group   => 'root',
    require => Package['nvidia-mig-manager'],
    notify  => Service['nvidia-mig-manager'],
  }

  service { 'nvidia-mig-manager':
    enable  => true,
    require => [
      Package['nvidia-mig-manager'],
      File['/etc/systemd/system/nvidia-mig-manager.service.d/override.conf'],
    ],
  }
}
