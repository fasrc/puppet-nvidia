class nvidia::install (
  $version = 'installed'
){
  package { 'cuda-drivers':
    ensure  => $version,
    require => Yumrepo['cuda'],
    notify  => Exec['/usr/sbin/dkms autoinstall -m nvidia'],
  }
}
