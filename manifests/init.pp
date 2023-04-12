class nvidia (
  $enable_mig = false,
){
  include nvidia::repo
  include nvidia::install
  include nvidia::config
  include nvidia::dcgm
  include nvidia::nsight
  if $enable_mig {
    include nvidia::mig
  }
}
