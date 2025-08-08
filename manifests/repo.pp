# sets up repository for nvidia drivers
class nvidia::repo (
  Boolean           $manage_repo     = true,
  String            $repo_ensure     = 'present',
  String            $repo_baseurl    = "http://fasrc-mirror.s3-website-us-east-1.amazonaws.com/cuda-el${::operatingsystemmajrelease}",
  Integer           $repo_gpgcheck   = 0,
  Integer           $repo_enabled    = 1,
  String            $repo_proxy      = '_none_',
  String            $repo_gpgkey     = '',
  Optional[Boolean] $module_hotfixes = undef
){
  if $manage_repo {
    yumrepo { 'cuda':
      descr           => 'Cuda Yum Repo',
      baseurl         => $repo_baseurl,
      gpgcheck        => $repo_gpgcheck,
      gpgkey          => $repo_gpgkey,
      enabled         => $repo_enabled,
      proxy           => $repo_proxy,
      module_hotfixes => $module_hotfixes
    }
  }
}
