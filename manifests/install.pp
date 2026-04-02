class nvidia::install (
  String  $version              = 'installed',
  String  $gdrcopy_version      = 'installed',
  String  $gds_version          = 'installed',
  String  $ucx_version          = 'present',
  Array   $ucx_pkgs             = ['ucx-cuda','ucx-gdrcopy'],
  Array   $nvidia_packages      = ['nvidia-driver','nvidia-driver-cuda','nvidia-settings','nvidia-xconfig','nvidia-libXNVCtrl-devel','nvidia-persistenced','nvidia-driver-NVML'],
  Array   $nvidia_kmod_packages = ['nvidia-modprobe','kmod-nvidia-latest-dkms'],
  String  $gds_package          = 'nvidia-gds-12-9',
){

  package { $nvidia_kmod_packages:
    ensure  => $version,
    require => Yumrepo['cuda'],
  }

  package {'nvidia-container-toolkit':
    ensure  => 'installed',
    require => Yumrepo['cuda'],
  }

  package { $nvidia_packages:
    ensure  => $version,
    require => [ 
      Yumrepo['cuda'],
      Package[$nvidia_kmod_packages],
      Package['nvidia-container-toolkit'],
    ],
    notify  => Exec['build-dkms-nvidia-module'],
  }

  file {'/usr/lib64/libnvidia-ml.so':
    ensure => 'link',
    target => '/usr/lib64/libnvidia-ml.so.1',
  }
  
  exec { 'build-dkms-nvidia-module':
    command     => '/usr/sbin/dkms autoinstall -m nvidia',
    refreshonly => true,
    notify      => Exec['build-cdi-config'],
  }

  exec { 'build-cdi-config':
    command     => '/usr/bin/nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml',
    refreshonly => true,
    require     => Package['nvidia-container-toolkit'],
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

  package { $gds_package:
    ensure  => $gds_version,
    require => Package['gdrcopy'],
  }
}
