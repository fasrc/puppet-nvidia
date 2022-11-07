class nvidia::install (
  $version = 'installed'
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
}
