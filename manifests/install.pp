class nvidia::install (
  String $version         = 'installed',
  String $gdrcopy_version = 'installed',
){
  package { 'cuda-drivers':
    ensure  => $version,
    require => Yumrepo['cuda'],
    notify  => Exec['build-dkms-nvidia-module'],
  }

  exec { 'build-dkms-nvidia-module':
    command => '/usr/sbin/dkms autoinstall -m nvidia',
    refreshonly => true,
  }

  package { ['gdrcopy','gdrcopy-kmod','gdrcopy-devel']::
    ensure  => $gdrcopy_version,
    require => Package['cuda-drivers'],
    notify  => Exec['build-dkms-gdrcopy-module'],
  }

  exec { 'build-dkms-gdrcopy-module':
    command => '/usr/sbin/dkms autoinstall -m gdrcopy',
    refreshonly => true,
  }
}
