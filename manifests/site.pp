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


  # node versions
  nodejs::version { 'v0.10.34': }
  class { 'nodejs::global': version => 'v0.10.34' }
  nodejs::module {    'bower':    node_version => 'v0.10.34'  }
  nodejs::module {    'gulp':    node_version => 'v0.10.34'  }
  nodejs::module {    'grunt-cli':    node_version => 'v0.10.34'  }
  nodejs::module {    'yo':    node_version => 'v0.10.34'  }
  nodejs::module {    'locally':    node_version => 'v0.10.34'  }

  # default ruby versions
  ruby::version { '2.0.0': }
  class { 'ruby::global':    version => '2.0.0'  }
  # ensure a gem is installed for all ruby versions
  ruby_gem { 'bundler for all rubies':
    gem          => 'bundler',
    version      => '~> 1.0',
    ruby_version => '*',
  }

  # common, useful brew packages
  package {
    [
      'ack',
      'findutils',
      'gnu-tar',
      'dos2unix',
      'privoxy',
      'git-flow',
      'the_silver_searcher',
      'tree',
      'w3m',
      'maven',
      'gradle',
      'tomcat6',
      'tomcat7',
      'screen',
      'autoconf',
      'autojump',
      'wget',
      'automake',
      'cmake',
      'ctags',
      'mr',
      'tmux',
      'pcre',
      'libpng',
      'libtool',
      'moreutils',
      'openssl'

    ]:
  }

  include openssl

  include phantomjs::1_9_0
  phantomjs::global { '1.9.0': }

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }



  # custom Dev Tools by theand
  include csshx
  include gitx

  include bash
  include bash::completion


  include php::5_4_29
  class { 'php::global':  version => '5.4.29' }
  include php::fpm::5_4_29
  include php::composer

  include java

  include mysql
  mysql::db { 'mydb': }

  include python
  include imagemagick
  include spf13vim3


  # custom Default OS X Settings by theand
  include osx::global::disable_key_press_and_hold
  include osx::global::enable_keyboard_control_access
  include osx::global::expand_print_dialog
  include osx::global::expand_save_dialog
  include osx::global::disable_autocorrect
  include osx::global::tap_to_click
  include osx::global::key_repeat_rate
  class { 'osx::global::key_repeat_delay':    delay => 30  }

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

  class { 'osx::dock::position':    position => 'left'  }
  class { 'osx::mouse::smart_zoom':    enabled => true  }
  class { 'osx::mouse::swipe_between_pages':    enabled => true  }

  include osx::sound::interface_sound_effects

  include mathiasdotfiles

  # custom GUI Apps by theand
  include imageoptim
  include magican
  include clipmenu
  include brow
  include xtrafinder
  include caffeine
  include googledrive
  include wunderlist
  include picasa

  class { 'intellij':
    edition => 'ultimate',
    version => '14.0.2'
  }
  class { 'phpstorm':    version => '8.0.2'  }

  include flux

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

  #include better_touch_tools
  include chrome
  include sublime_text::v2
  include atom

  include pow
  include dropbox
  include iterm2::stable

  class { 'firefox::nightly':    version => '37.0a1'  }

  include hipchat
  include alfred


  include ccleaner
  include fonts
  #include seil
  #include karabiner

  class {'filezilla':    version => '3.9.0.6'  }

  include mysql_workbench
  include haroopad
  include p4merge
  class {'brackets':    version => '1.1'  }
  #include macvim  #needs XCode


  class { 'sourcetree':    version  => "2.0.3"  }

  include appcleaner
  include pgadmin3
  include evernote

  include mypeople
  include daumcloud

}
