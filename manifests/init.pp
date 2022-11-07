class nvidia {
  include nvidia::repo
  include nvidia::install
  include nvidia::config
  include nvidia::dcgm
  include nvidia::nsight
}
