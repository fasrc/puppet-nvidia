class nvidia::install (
  String $version         = 'installed',
  String $gdrcopy_version = 'installed',
  Array  $ucx_pkgs        = ['ucx-cuda','ucx-gdrcopy'],
  String $ucx_version     = 'present',
){
  package { 'kmod-nvidia-latest-dkms':
    ensure  => $version,
    require => Yumrepo['cuda'],
  }

  package { 'cuda-drivers':
    ensure  => $version,
    require => [ 
      Yumrepo['cuda'],
      Package['kmod-nvidia-latest-dkms'],
    ],
    notify  => Exec['build-dkms-nvidia-module'],
  }

  exec { 'build-dkms-nvidia-module':
    command => '/usr/sbin/dkms autoinstall -m nvidia',
    refreshonly => true,
  }

  package { ['gdrcopy','gdrcopy-kmod','gdrcopy-devel']:
    ensure  => $gdrcopy_version,
    require => Package['cuda-drivers'],
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
