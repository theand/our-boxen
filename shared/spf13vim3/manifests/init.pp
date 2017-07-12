# This class installs spf13-vim-3
class spf13vim3 {
  exec {'install-spf13-vim-3':
    command => 'curl https://github.com/theand/spf13-vim/raw/theand/bootstrap.sh -L | bash -s',
    creates => "/Users/${::luser}/.spf13-vim-3",
    timeout => 0
  }
}
