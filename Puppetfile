# This file manages Puppet module dependencies.
#
# It works a lot like Bundler. We provide some core modules by
# default. This ensures at least the ability to construct a basic
# environment.

# Shortcut for a module from GitHub's boxen organization
def github(name, *args)
  options ||= if args.last.is_a? Hash
    args.last
  else
    {}
  end

  if path = options.delete(:path)
    mod name, :path => path
  else
    version = args.first
    options[:repo] ||= "boxen/puppet-#{name}"
    mod name, version, :github_tarball => options[:repo]
  end
end

# Shortcut for a module under development
def dev(name, *args)
  mod name, :path => "#{ENV['HOME']}/src/boxen/puppet-#{name}"
end

# Includes many of our custom types and providers, as well as global
# config. Required.

github "boxen", "3.7.0"

# Support for default hiera data in modules

github "module_data", "0.0.3", :repo => "ripienaar/puppet-module-data"

# Core modules for a basic development environment. You can replace
# some/most of these if you want, but it's not recommended.

github "dnsmasq",     "2.0.1"
github "foreman",     "1.2.0"
github "gcc",         "2.2.0"
github "git",         "2.7.0"
github "go",          "2.1.0"
github "homebrew",    "1.9.8"
github "hub",         "1.3.0"
github "inifile",     "1.1.1", :repo => "puppetlabs/puppetlabs-inifile"
github "nginx",       "1.4.4"
github "nodejs",      "4.0.0"
github "openssl",     "1.0.0"
github "phantomjs",   "2.3.0"
github "pkgconfig",   "1.0.0"
github "repository",  "2.3.0"
github "ruby",        "8.1.7"
github "stdlib",      "4.2.1", :repo => "puppetlabs/puppetlabs-stdlib"
github "sudo",        "1.0.0"
github "xquartz",     "1.2.1"

# Optional/custom modules. There are tons available at
# https://github.com/boxen.

# custom Dev Tools by theand
github "csshx",  "1.0.0"
github "imageoptim",  "0.0.2"
github "tmux",  "1.0.2"
github "gitx",  "1.2.0"
github "nvm",  "1.0.0"
github "screen",  "0.0.2"
github "zsh",  "1.0.0"
github "ghostscript",  "1.0.0"
github "pcre",  "1.0.0"
github "libtool",  "1.0.0"
github "wkhtmltopdf",  "1.2.1"
github "autojump",  "1.0.0"
github "autoconf",  "1.0.0"
github "xctool",  "0.0.2"
github "wget",  "1.0.1"
github "moreutils",  "1.0.0"
github "libpng",  "1.0.0"
github "automake",  "1.0.0"
github "cmake",  "1.0.1"
github "zshgitprompt",  "1.0.2"
github "mr",  "1.0.1"
github "vim",  "1.0.5"
github "ctags",  "1.0.0"
github "docker",  "0.7.0"
github "osx",  "2.8.0"
github "php",  "1.2.6"
github "java",  "1.7.1"
github "bash",  "1.1.0"
github "mysql",  "1.99.18"
github "python",  "2.0.0"
github "imagemagick",  "1.3.0"


# custom GUI Apps by theand
github "magican",  "1.0.2"
github "clipmenu",  "1.0.0"
github "brow",  "1.0.0"
github "postgresapp",  "1.0.0"
github "xtrafinder",  "1.0.1"
github "caffeine",  "1.0.0"
github "googledrive",  "1.0.2"
github "induction",  "1.0.0"
github "wunderlist",  "1.0.0"
github "picasa",  "1.0.0"
github "macvim",  "1.0.0"
github "osxfuse",  "1.3.0"
github "ntfs_3g",  "1.0.0", :repo => "MoOx/puppet-ntfs_3g"
github "intellij",  "1.5.1"
github "sourcetree",  "1.0.0"
github "flux",  "1.0.1"
github "adobe_reader",  "1.2.0"
github "mplayerx",  "1.0.2"
github "openoffice",  "1.2.0"
github "ccleaner",  "1.1.0"
github "sequel_pro",  "1.0.1"
github "appcleaner",  "1.0.0"
github "dterm",  "1.0.2"
github "reggy",  "1.0.1"
github "opera",  "0.3.3"
github "fonts",  "0.0.3"
github "virtualbox",  "1.0.13"
github "dash",  "1.0.0"
github "pgadmin3",  "1.0.0"
github "github_for_mac",  "1.0.3"
github "vagrant",  "3.2.0"
github "better_touch_tools",  "3.0.0"
github "chrome",  "1.2.0"
github "seil",  "1.0.2"
github "sublime_text",  "1.1.0"
github "atom",  "1.1.0"
github "libreoffice",  "4.2.6"
github "pow",  "2.3.0"
github "evernote",  "2.0.7"
github "dropbox",  "1.4.1"
github "iterm2",  "1.2.2"
github "firefox",  "1.2.3"
github "vagrant_manager",  "0.0.1"
github "secondbar",  "1.0.1"



