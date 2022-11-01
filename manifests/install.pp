class nvidia::install (
  $version = 'installed'
){
  package { 'cuda-drivers':
    ensure  => $version,
    require => Yumrepo['cuda'],
  } ~> exec { '/usr/sbin/dkms autoinstall -m nvidia': }
}
