# Installs dcgm and starts service
class nvidia::dcgm {
  package { 'datacenter-gpu-manager':
    ensure => absent,
  }

  package { 'datacenter-gpu-manager-4':
    ensure => latest,
  }

  service { 'nvidia-dcgm':
    ensure => 'running',
    enable => true,
    require => [
      Package['datacenter-gpu-manager'],
    ],
  }

  package { 'dcgm-exporter':
    ensure => latest,
    notify => Service['prometheus-dcgm-exporter'],
  }

  file { '/etc/dcgm-exporter/default-counters.csv':
    source => 'puppet:///modules/nvidia/default-counters.csv',
    owner  => 'root',
    group  => 'root',
    notify => Service['prometheus-dcgm-exporter'],
  }

  service { 'prometheus-dcgm-exporter':
    ensure => 'running',
    enable => true,
    require => [
      Package['dcgm-exporter'],
    ],
  }
}
