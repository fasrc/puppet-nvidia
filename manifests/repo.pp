# sets up repository for nvidia drivers
class nvidia::repo (
  $manage_repo   = true,
  $repo_ensure   = 'present',
  $repo_baseurl  = 'http://fasrc-mirror.s3-website-us-east-1.amazonaws.com/cuda-el%{::lsbmajdistrelease}',
  $repo_gpgcheck = 0,
  $repo_enabled  = 1,
  $repo_proxy    = '_none_',
  $repo_gpgkey   = '',
){
  if $manage_repo {
    yumrepo { 'cuda':
      descr    => 'Cuda Yum Repo',
      baseurl  => $repo_baseurl,
      gpgcheck => $repo_gpgcheck,
      gpgkey   => $repo_gpgkey,
      enabled  => $repo_enabled,
      proxy    => $repo_proxy,
    }
  }
}
