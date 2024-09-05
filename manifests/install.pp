class nvidia::install (
  String $version         = 'installed',
  String $gdrcopy_version = 'installed',
  Array  $ucx_pkgs        = ['ucx-cuda','ucx-gdrcopy'],
  Array  $nvidia_packages = ['nvidia-driver','nvidia-driver-cuda','nvidia-settings','nvidia-xconfig','nvidia-libXNVCtrl-devel','nvidia-persistenced','cuda-driver','nvidia-driver-NVML'],
  String $ucx_version     = 'present',
){
  package { 'kmod-nvidia-latest-dkms':
    ensure  => $version,
    require => Yumrepo['cuda'],
  }

  package { $nvidia_packages:
    ensure  => $version,
    require => [ 
      Yumrepo['cuda'],
      Package['kmod-nvidia-latest-dkms'],
    ],
    notify  => Exec['build-dkms-nvidia-module'],
  }

  file {'/usr/lib64/libnvidia-ml.so':
    ensure => 'link',
    target => '/usr/lib64/libnvidia-ml.so.1',
  }
  
  exec { 'build-dkms-nvidia-module':
    command => '/usr/sbin/dkms autoinstall -m nvidia',
    refreshonly => true,
  }

  package { ['gdrcopy','gdrcopy-kmod','gdrcopy-devel']:
    ensure  => $gdrcopy_version,
    require => Package['nvidia-driver'],
    notify  => Exec['build-dkms-gdrcopy-module'],
  }

  exec { 'build-dkms-gdrcopy-module':
    command => '/usr/sbin/dkms autoinstall -m gdrcopy',
    refreshonly => true,
  }

  package { $ucx_pkgs:
    ensure  => $ucx_version,
    require => Package['gdrcopy'],
  }
}
