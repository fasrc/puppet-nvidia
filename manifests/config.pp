class nvidia::config {
  service { 'nvidia-persistenced':
    enable => true,
    require => Package['nvidia-persistenced'],
  }
}
