# Installs dcgm and starts service
class nvidia::dcgm {
  package { 'datacenter-gpu-manager':
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
  }
  service { 'prometheus-dcgm-exporter':
    ensure => 'running',
    enable => true,
    require => [
      Package['dcgm-exporter'],
    ],
  }
}
