require boxen::environment
require homebrew
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
  include git

  # common, useful brew packages
  # package {
  #   [
  #   ]:
  # }

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }


  # custom Dev Tools by theand

  $python_version = "2.7.13"
  python::version { $python_version: }
  # Set the global version of Python
  class { 'python::global':    version => $python_version }

  $ruby_version = "2.4.1"
  class { 'ruby::global':    version => $ruby_version }
  # ensure a gem is installed for all ruby versions
  ruby_gem { 'bundler for all rubies':
    gem          => 'bundler',
    version      => '~> 1.15.1',
    ruby_version => "*",
  }


  include spf13vim3
  include mathiasdotfiles

  # START - custom Default OS X Settings from https://github.com/boxen/puppet-osx
  # Global Settings
  include osx::global::disable_key_press_and_hold
  include osx::global::enable_keyboard_control_access
  include osx::global::enable_standard_function_keys
  include osx::global::expand_print_dialog
  include osx::global::expand_save_dialog
  include osx::global::disable_remote_control_ir_receiver
  include osx::global::disable_autocorrect
  include osx::global::tap_to_click

  # Dock Settings
  include osx::dock::icon_size
  include osx::dock::pin_position
  include osx::dock::dim_hidden_apps

  # Finder Settings
  include osx::finder::unhide_library
  include osx::finder::enable_quicklook_text_selection
  include osx::finder::show_all_filename_extensions

  # Universal Access Settings
  include osx::universal_access::ctrl_mod_zoom
  include osx::universal_access::enable_scrollwheel_zoom

  # Safari Settings
  include osx::safari::enable_developer_mode

  # Miscellaneous Settings
  include osx::disable_app_quarantine
  include osx::no_network_dsstores

  # Customizable Settings
  class { 'osx::global::key_repeat_delay':    delay => 30  }
  include osx::global::key_repeat_rate

  class { 'osx::dock::position':    position => 'left'  }

  include osx::sound::interface_sound_effects

  class { 'osx::mouse::smart_zoom':    enabled => true  }
  class { 'osx::mouse::swipe_between_pages':    enabled => true  }

  class { 'osx::dock::magnification':
    magnification => true,
    magnification_size => 84
  }
  # END of osx

  # custom GUI Apps by theand
  class { 'sublime_text':
    build                  => '3126',
    package_control_ensure => '3c6f58392f22c781750b01efc5f36a5fb49efd68',
    package_control_source => 'wbond/package_control'
  }

  include iterm2::stable
  include iterm2::colors::solarized_dark

}
