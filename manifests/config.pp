class nvidia::config (
  Boolean $powercap_enable    = false,
  String  $powercap_service   = 'stopped',
  String  $powercap           = '550',
){
  service { 'nvidia-persistenced':
    enable  => true,
    ensure  => 'running',
    require => [
      Package['nvidia-persistenced'],
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
  
  systemd::unit_file { 'nvidia-powercap.service':
    content => template('nvidia/nvidia-powercap.service.erb'),
    enable  => $powercap_enable,
    require => [
      Package['nvidia-persistenced'],
    ],
  }
  ~> service { 'nvidia-powercap':
    ensure => $powercap_service,
  }
}
