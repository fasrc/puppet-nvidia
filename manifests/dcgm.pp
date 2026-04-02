# Installs dcgm and starts service
class nvidia::dcgm (
  String $dcgm_service_ensure  = 'running',
  String $dcgm_exporter_ensure = 'running',
  String $nscq_package         = 'libnvidia-nscq-575-575.57.08-1.x86_64',
){
  package { 'datacenter-gpu-manager':
    ensure => absent,
  }

  package { 'datacenter-gpu-manager-4':
    ensure => latest,
    notify => [
      Service['prometheus-dcgm-exporter'],
      Service['nvidia-dcgm'],
    ],
  }

  package { $nscq_package:
    ensure => installed,
    notify => [
      Service['prometheus-dcgm-exporter'],
      Service['nvidia-dcgm'],
    ],
  }

  service { 'nvidia-dcgm':
    ensure => $dcgm_service_ensure,
    enable => true,
    require => [
      Package['datacenter-gpu-manager'],
    ],
  }

  package { 'dcgm-exporter':
    ensure => latest,
    notify => Service['prometheus-dcgm-exporter'],
  }

  file { '/etc/dcgm-exporter/dcgm-counters.csv':
    source => 'puppet:///modules/nvidia/dcgm-counters.csv',
    owner  => 'root',
    group  => 'root',
    notify => Service['prometheus-dcgm-exporter'],
  }
  
  systemd::dropin_file { '10-config.conf':
    unit    => 'prometheus-dcgm-exporter.service',
    content => "[Service]\nExecStart=\nExecStart=/usr/bin/dcgm-exporter -f /etc/dcgm-exporter/dcgm-counters.csv",
    require => File['/etc/dcgm-exporter/dcgm-counters.csv'],
  }

  service { 'prometheus-dcgm-exporter':
    ensure => $dcgm_exporter_ensure,
    enable => true,
    require => [
      Package['dcgm-exporter'],
    ],
  }
}
