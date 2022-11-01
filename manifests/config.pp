class nvidia::config {
  service { 'nvidia-persistenced':
    enable  => true,
    ensure  => 'running',
    require => [
      File['/usr/lib/systemd/system/nvidia-persistenced.service'],
    ],
  }
}
