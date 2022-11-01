class nvidia::config {
  service { 'nvidia-persistenced':
    enable  => true,
    ensure  => 'running',
    require => [
      Package['cuda-drivers'],
    ],
  }
}
