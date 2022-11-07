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
}
