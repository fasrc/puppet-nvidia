class nvidia::install (
  Boolean $versionlock    = 'false',
  String  $version         = 'installed',
  String  $release         = '1.el8',
  String  $arch            = 'x86_64',
  String  $gdrcopy_version = 'installed',
  Array   $ucx_pkgs        = ['ucx-cuda','ucx-gdrcopy'],
  Array   $nvidia_packages = ['nvidia-driver','nvidia-driver-cuda','nvidia-settings','nvidia-xconfig','nvidia-libXNVCtrl-devel','nvidia-persistenced','nvidia-driver-NVML'],
  String  $ucx_version     = 'present',
){

  if $versionlock {
    yum::versionlock { $nvidia_packages:
      ensure  => present,
      version => $version,
      release => $release,
      arch    => $arch,
    }

    yum::versionlock { ['kmod-nvidia-latest-dkms','nvidia-modprobe']:
      ensure  => present,
      version => $version,
      release => $release,
      arch    => $arch,
    }
  }

  package { 'kmod-nvidia-latest-dkms':
    ensure  => $version-$release.$arch,
    require => Yumrepo['cuda'],
  }

  package {'nvidia-container-toolkit':
    ensure  => 'installed',
    require => Yumrepo['cuda'],
  }

  package { $nvidia_packages:
    ensure  => $version-$release.$arch,
    require => [ 
      Yumrepo['cuda'],
      Package['kmod-nvidia-latest-dkms'],
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
}
