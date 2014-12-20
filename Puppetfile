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

github "boxen", "3.7.1", :repo => "theand/puppet-boxen"

# Support for default hiera data in modules

github "module_data", "0.0.3", :repo => "ripienaar/puppet-module-data"

# Core modules for a basic development environment. You can replace
# some/most of these if you want, but it's not recommended.

github "dnsmasq",     "2.0.1"
github "gcc",         "2.2.0"
github "git",         "2.7.1"
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
github "tmux",  "1.0.2"
github "gitx",  "1.2.0"
github "screen",  "1.0.0"
github "bash",  "1.1.0"
github "pcre",  "1.0.0"
github "libtool",  "1.0.0"
github "autojump",  "1.0.0"
github "autoconf",  "1.0.0"
github "wget",  "1.0.1"
github "moreutils",  "1.0.0"
github "libpng",  "1.0.0"
github "automake",  "1.0.0"
github "cmake",  "1.0.1"
github "mr",  "1.0.1"
github "ctags",  "1.0.0"
github "php",  "1.2.6"
github "java",  "1.7.1"
github "mysql",  "1.99.19.1", :repo => "theand/puppet-mysql"
github "python",  "2.0.0"
github "imagemagick",  "1.3.0"
github "spf13vim3",  "1.0.0", :repo => "samjsharpe/puppet-spf13vim3"


# custom Default OS X Settings by theand
github "osx",  "2.8.0"

# custom GUI Apps by theand
github "imageoptim",  "0.0.2"
github "magican",  "1.0.2"
github "clipmenu",  "1.0.0"
github "brow",  "1.0.0"
github "xtrafinder",  "1.0.1"
github "caffeine",  "1.0.0"
github "googledrive",  "1.0.2"
github "wunderlist",  "1.0.0"
github "picasa",  "1.0.0"
github "intellij",  "1.5.1"
github "phpstorm",  "1.0.6"
github "flux",  "1.0.1"
github "sequel_pro",  "1.0.1"
github "dterm",  "0.1.2"
github "reggy",  "1.0.2"
github "opera",  "0.3.3"
github "virtualbox",  "1.0.13"
github "dash",  "1.0.0"
github "github_for_mac",  "1.0.3"
github "vagrant",  "3.2.0"
github "better_touch_tools",  "3.0.0"
github "chrome",  "1.2.0"
github "sublime_text",  "1.1.0"
github "atom",  "1.1.0"
github "pow",  "2.3.0"
github "dropbox",  "1.4.1"
github "iterm2",  "1.2.2"
github "firefox",  "1.2.3"
github "hipchat",  "1.1.3"
github "alfred",  "1.4.0"
github "ccleaner",  "1.1.1", :repo => "theand/puppet-ccleaner"
github "fonts",  "0.0.5", :repo => "theand/puppet-fonts"
github "seil",  "1.0.3", :repo => "theand/puppet-seil"
github "karabiner", "1.0.7", :repo => "theand/puppet-karabiner"
github "filezilla",  "0.3.0", :repo => "theand/puppet-filezilla"
github "mysql_workbench",  "0.0.4", :repo => "theand/puppet-mysql_workbench"
github "haroopad",  "0.0.3", :repo => "theand/puppet-haroopad"
github "p4merge",  "0.0.5", :repo => "theand/puppet-p4merge"
github "brackets",  "0.1.3", :repo => "theand/puppet-brackets"
github "macvim",  "1.0.1", :repo => "theand/puppet-macvim"
github "sourcetree",  "1.0.2", :repo => "theand/puppet-sourcetree"
github "appcleaner",  "1.0.1", :repo => "theand/puppet-appcleaner"
github "pgadmin3",  "1.0.1", :repo => "theand/puppet-pgadmin3"
github "evernote",  "2.0.8", :repo => "theand/puppet-evernote"
github "mypeople",  "0.0.1", :repo => "theand/puppet-mypeople"

