class nvidia::config {
  service { 'nvidia-persistenced':
    enable  => true,
    ensure  => 'running',
    require => [
      Package['cuda-drivers'],
    ],
  }

  systemd::unit_file { 'nvidia-peermem.service':
    content => file('nvidia/nvidia-peermem.service'),
    enable  => true,
  }

  file { '/etc/modprobe.d/nvidia.conf':
    source => 'puppet:///modules/nvidia/nvidia.conf',
    owner  => 'root',
    group  => 'root',
  }
}
