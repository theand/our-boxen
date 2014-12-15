require boxen::environment
require homebrew
require gcc

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $boxen_user,

  path => [
    "${boxen::config::home}/rbenv/shims",
    "${boxen::config::home}/rbenv/bin",
    "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
    "${boxen::config::home}/homebrew/bin",
    '/usr/bin',
    '/bin',
    '/usr/sbin',
    '/sbin'
  ],

  environment => [
    "HOMEBREW_CACHE=${homebrew::config::cachedir}",
    "HOME=/Users/${::boxen_user}"
  ]
}

File {
  group => 'staff',
  owner => $boxen_user
}

Package {
  provider => homebrew,
  require  => Class['homebrew']
}

Repository {
  provider => git,
  extra    => [
    '--recurse-submodules'
  ],
  require  => File["${boxen::config::bindir}/boxen-git-credential"],
  config   => {
    'credential.helper' => "${boxen::config::bindir}/boxen-git-credential"
  }
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>

node default {
  # core modules, needed for most things
  include dnsmasq
  include git
  include hub
  include nginx


  # fail if FDE is not enabled
  #if $::root_encrypted == 'no' {
    #fail('Please enable full disk encryption and try again')
  #}

  # node versions
  nodejs::version { 'v0.10': }

  # default ruby versions
  ruby::version { '1.9.3': }
  ruby::version { '2.0.0': }
  ruby::version { '2.1.2': }

  # common, useful packages
  package {
    [
      'ack',
      'findutils',
      'gnu-tar'
    ]:
  }

  include foreman
  include go
  include openssl
  include phantomjs

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }



  # custom Dev Tools by theand
  include csshx
  include imageoptim
  include tmux
  include gitx
  include screen
  include zsh
  include ghostscript
  include pcre
  include libtool
  include autojump
  include autoconf
  include wget
  include moreutils
  include libpng
  include automake
  include cmake
  include zshgitprompt
  include mr
  include ctags
  include php::5_4
  include java

  include mysql
  mysql::db { 'mydb': }

  include python
  include imagemagick
  include docker


  include osx::global::disable_key_press_and_hold
  include osx::global::enable_keyboard_control_access
  include osx::global::expand_print_dialog
  include osx::global::expand_save_dialog
  include osx::global::disable_autocorrect
  include osx::global::tap_to_click
  include osx::global::key_repeat_rate
  class { 'osx::global::key_repeat_delay':
    delay => 10
  }

  include osx::finder::unhide_library
  include osx::finder::show_hidden_files
  include osx::finder::enable_quicklook_text_selection
  include osx::finder::show_all_filename_extensions

  include osx::universal_access::ctrl_mod_zoom
  include osx::universal_access::enable_scrollwheel_zoom
  include osx::safari::enable_developer_mode

  include osx::disable_app_quarantine
  include osx::no_network_dsstores

  include osx::dock::icon_size
  include osx::dock::pin_position
  include osx::dock::dim_hidden_apps

  class { 'osx::dock::magnification':
    magnification => true,
    magnification_size => 84
  }

  class { 'osx::dock::position':
    position => 'left'
  }

  class { 'osx::mouse::smart_zoom':
    enabled => true
  }
  class { 'osx::mouse::swipe_between_pages':
    enabled => true
  }

  include osx::sound::interface_sound_effects


  # custom GUI Apps by theand
  include magican
  include clipmenu
  include brow
  include xtrafinder
  include caffeine
  include googledrive
  include induction
  include wunderlist
  include picasa

  class { 'intellij':
    edition => 'ultimate',
    version => '14.0.2'
  }
  class { 'phpstorm':
    version => '8.0.2'
  }

  include flux

  class { 'openoffice':
    version  => "4.1.1"
  }

  include sequel_pro
  include dterm
  include reggy
  include opera

  class { 'virtualbox':
    version  => "4.3.20",
    patch_level  => "96996"
  }

  include dash
  include github_for_mac

  class { 'vagrant':
    version  => "1.7.1",
    completion => true
  }

  include better_touch_tools
  include chrome
  include sublime_text::v2
  include atom

  class { 'libreoffice':
    version => '4.3.4'
  }

  include pow
  include dropbox
  include iterm2::stable
  include firefox::nightly
  include hipchat
  include alfred


  include postgresapp
  include ccleaner
  include fonts
  include seil
  include vagrant_manager
  include karabiner

  class {'filezilla':
    version => '3.9.0.6'
  }

  include mysql_workbench
  include haroopad
  include p4merge
  include brackets
  include macvim

  class { 'sourcetree':
    version  => "2.0.3"
  }

  include appcleaner
  include pgadmin3
  include evernote

  include spf13vim3


}
