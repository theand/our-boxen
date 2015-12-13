require boxen::environment
require homebrew
#require gcc
include brewcask

Exec {
  group       => 'staff',
  logoutput   => on_failure,
  user        => $boxen_user,

  path => [
    "${boxen::config::home}/rbenv/shims",
    "${boxen::config::home}/rbenv/bin",
    "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
    "${boxen::config::homebrewdir}/bin",
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
  $node_version = '4.2.3'
  class { 'nodejs::global': version => $node_version }
  npm_module { "bower for ${version}":  module => 'bower', version => '~> 1.4.1', node_version => $version, }
  npm_module { "gulp for ${version}":  module => 'gulp', version => '~> 3.9.0', node_version => $version, }
  npm_module { "grunt-cli for ${version}":  module => 'grunt-cli', version => '~> 0.1.13', node_version => $version, }
  npm_module { "yo for ${version}":  module => 'yo', version => '~> 1.4.7', node_version => $version, }
  npm_module { "locally for ${version}":  module => 'locally', version => '~> 0.2.1', node_version => $version, }

  # default ruby versions
  $ruby_version = "2.2.3"
  class { 'ruby::global':    version => $ruby_version }
  # ensure a gem is installed for all ruby versions
  ruby_gem { 'bundler for all rubies':
    gem          => 'bundler',
    version      => '~> 1.10.5',
    ruby_version => "*",
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
      'tomcat7',
      'autojump',
      'automake',
      'cmake',
      'ctags',
      'mr',
      'tmux',
      'moreutils',
      'icdiff'

    ]:
  }

  include openssl

#  phantomjs::version { '2.0.0': }
#  phantomjs::global { '2.0.0': }

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }



  # custom Dev Tools by theand
#  include csshx

#  include bash
#  include bash::completion


#  include java

  include mysql
  mysql::db { 'mydb': }

#  include python
#  include imagemagick
#  include spf13vim3


  # custom Default OS X Settings by theand
#  include osx::global::disable_key_press_and_hold
#  include osx::global::enable_keyboard_control_access
#  include osx::global::expand_print_dialog
#  include osx::global::expand_save_dialog
#  include osx::global::disable_autocorrect
#  include osx::global::tap_to_click
#  include osx::global::key_repeat_rate
#  class { 'osx::global::key_repeat_delay':    delay => 30  }

#  include osx::finder::unhide_library
#  include osx::finder::show_hidden_files
#  include osx::finder::enable_quicklook_text_selection
#  include osx::finder::show_all_filename_extensions

#  include osx::universal_access::ctrl_mod_zoom
#  include osx::universal_access::enable_scrollwheel_zoom
#  include osx::safari::enable_developer_mode

#  include osx::disable_app_quarantine
#  include osx::no_network_dsstores

#  include osx::dock::icon_size
#  include osx::dock::pin_position
#  include osx::dock::dim_hidden_apps

#  class { 'osx::dock::magnification':
#    magnification => true,
#    magnification_size => 84
#  }

#  class { 'osx::dock::position':    position => 'left'  }
#  class { 'osx::mouse::smart_zoom':    enabled => true  }
#  class { 'osx::mouse::swipe_between_pages':    enabled => true  }

#  include osx::sound::interface_sound_effects

#  include mathiasdotfiles

  # custom GUI Apps by theand
#  include imageoptim
#  include xtrafinder
#  include caffeine
#  include googledrive
#  include wunderlist
#  include picasa

#  class { 'intellij':    edition => 'ultimate',    version => '14.1.5-custom-jdk-bundled'  }
#  class { 'phpstorm':    version => '10.0.1-custom-jdk-bundled'  }

#  include flux

#  include sequel_pro

#  class { 'virtualbox':    version  => "5.0.10",    patch_level  => "104061"  }

#  package { 'github-desktop': provider => 'brewcask' }

#  class { 'vagrant':    version  => "1.7.4",    completion => true  }

#  include chrome
#  include sublime_text
#  include atom

#  include pow

#  class { 'dropbox':    version => '3.12.4'  }

#  include iterm2::dev
#  include iterm2::colors::solarized_dark

#  class { 'firefox::nightly':  }

#  include hipchat
#  class { 'alfred':  version => '2.8.1_425' }


#  include ccleaner
#  include fonts

#  include mysql_workbench
#  include haroopad
#  include p4merge
#  class {'brackets':    version => '1.5'  }

#  class { 'sourcetree':    version  => "2.0.5.2"  }

#  class { 'appcleaner':    version  => "2.3"  }
#  include pgadmin3

  package { 'evernote': provider => 'brewcask' }
}
