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

  file { '/etc/nvidia-mig-manager/config.yaml' :
    ensure  => link,
    target  => '/etc/nvidia-mig-manager/config-default.yaml',
    require => Package['nvidia-mig-manager'],
  }

  file { '/etc/nvidia-mig-manager/hooks.yaml' :
    ensure  => link,
    target  => '/etc/nvidia-mig-manager/hooks-default.yaml',
    require => Package['nvidia-mig-manager'],
  }

  service { 'nvidia-mig-manager':
    enable  => true,
    require => [
      Package['nvidia-mig-manager'],
      File['/etc/systemd/system/nvidia-mig-manager.service.d/override.conf'],
      File['/etc/nvidia-mig-manager/config.yaml'],
      File['/etc/nvidia-mig-manager/hooks.yaml'],
    ],
  }
}
