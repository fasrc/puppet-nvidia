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
    ensure => 'running',
    enable => true,
    require => [
      Package['dcgm-exporter'],
    ],
  }
}
