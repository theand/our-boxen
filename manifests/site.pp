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
  package {
    [
      'ack',
      'autojump',
      'automake',
      'bash',
      'bash-completion2',
      'cmake',
      'ctags',
      'dos2unix',
      'findutils',
      'fzf',
      'git-flow',
      'git-lfs',
      'gnu-sed',
      'gnu-tar',
      'httpie',
      'icdiff',
      'imagemagick',
      'moreutils',
      'node',
      'openssl',
      'privoxy',
      'recode',
      'ssh-copy-id',
      'the_silver_searcher',
      'tmux',
      'tree',
      'vim',
      'wget'
    ]:
  }

  file { "${boxen::config::srcdir}/our-boxen":
    ensure => link,
    target => $boxen::config::repodir
  }


  # custom Dev Tools by theand

  $ruby_version = "2.4.0"
  class { 'ruby::global':    version => $ruby_version }
  # ensure a gem is installed for all ruby versions
  ruby_gem { 'bundler for all rubies':
    gem          => 'bundler',
    version      => '~> 1.13.7',
    ruby_version => "*",
  }


  include spf13vim3
  include mathiasdotfiles

  # START - custom Default OS X Settings by theand
  include osx::global::disable_key_press_and_hold
  include osx::global::enable_keyboard_control_access
  include osx::global::expand_print_dialog
  include osx::global::expand_save_dialog
  include osx::global::disable_autocorrect
  include osx::global::tap_to_click
  include osx::global::key_repeat_rate
  class { 'osx::global::key_repeat_delay':    delay => 30  }

  include osx::finder::unhide_library
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
  # END

  # custom GUI Apps by theand
  include sublime_text

  include iterm2::stable
  include iterm2::colors::solarized_dark

  package { 'appcleaner': provider => 'brewcask' }
  package { 'appdelete': provider => 'brewcask' }
  package { 'atom': provider => 'brewcask' }
  package { 'ccleaner': provider => 'brewcask' }
  package { 'dropbox': provider => 'brewcask' }
  package { 'duet': provider => 'brewcask' }
  package { 'evernote': provider => 'brewcask' }
  package { 'firefox': provider => 'brewcask' }
  package { 'flux': provider => 'brewcask' }
  package { 'google-chrome': provider => 'brewcask' }
  package { 'google-drive': provider => 'brewcask' }
  package { 'hyper': provider => 'brewcask' }
  package { 'macdown': provider => 'brewcask' }
  package { 'malwarebytes-anti-malware': provider => 'brewcask' }
  package { 'mysqlworkbench': provider => 'brewcask' }
  package { 'near-lock': provider => 'brewcask' }
  package { 'opera': provider => 'brewcask' }
  package { 'p4merge': provider => 'brewcask' }
  package { 'pgadmin4': provider => 'brewcask' }
  package { 'scroll-reverser': provider => 'brewcask' }
  package { 'slack': provider => 'brewcask' }
  package { 'sourcetree': provider => 'brewcask' }
  package { 'telegram-desktop': provider => 'brewcask' }
  package { 'vmware-horizon-client': provider => 'brewcask' }

}
