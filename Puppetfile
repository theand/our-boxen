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
  mod "puppet-#{name}", :path => "#{ENV['HOME']}/src/boxen/puppet-#{name}"
end

# Includes many of our custom types and providers, as well as global
# config. Required.

github "boxen", "3.11.1.theand", :repo => "theand-boxen/puppet-boxen"

# Support for default hiera data in modules

github "module_data", "0.0.4", :repo => "ripienaar/puppet-module-data"

# Core modules for a basic development environment. You can replace
# some/most of these if you want, but it's not recommended.

github "brewcask",    "0.0.6"
github "dnsmasq",     "2.0.1"
# github "gcc",         "3.0.2"
github "git",         "2.7.11"
github "homebrew",    "2.0.0.4.theand", :repo => "theand-boxen/puppet-homebrew"
github "hub",         "1.4.1"
github "inifile",     "1.4.2", :repo => "puppetlabs/puppetlabs-inifile"
github "nginx",       "1.6.0"
github "nodejs",      "5.0.5"
github "openssl",     "1.0.0"
# github "phantomjs",   "3.0.0"
github "pkgconfig",   "1.0.0"
github "repository",  "2.4.1"
github "ruby",        "8.5.3"
github "stdlib",      "4.9.1", :repo => "puppetlabs/puppetlabs-stdlib"
github "sudo",        "1.0.0"
# github "xquartz",     "1.2.1"

# Optional/custom modules. There are tons available at
# https://github.com/boxen.
# github "elasticsearch", "2.8.0"
# github "mysql",         "2.0.1"
# github "postgresql",  "4.0.1"
# github "redis",       "3.1.0"
# github "sysctl",      "1.0.1"

# custom Dev Tools by theand
# github "csshx",  "1.0.0"
# github "bash",  "1.1.0"
# github "java",  "1.8.4"
# github "python",  "2.0.1"
# github "imagemagick",  "1.3.0"
# github "vagrant",  "3.3.3"
github "mysql",  "2.2.0", :repo => "theand-boxen/puppet-mysql"
# github "spf13vim3",  "1.0.1", :repo => "theand-boxen/puppet-spf13vim3"


# custom Default OS X Settings by theand
# github "osx",  "2.8.0"
# github "mathiasdotfiles",  "0.0.2", :repo => "theand-boxen/puppet-mathiasdotfiles"

# custom GUI Apps by theand
# github "imageoptim",  "0.0.2"
# github "xtrafinder",  "1.0.1"
# github "caffeine",  "1.0.0"
# github "googledrive",  "1.0.2"
# github "wunderlist",  "1.0.0"
# github "picasa",  "1.0.1", :repo => "theand-boxen/puppet-picasa"
# github "intellij",  "1.5.1"
# github "phpstorm",  "1.0.6"
# github "flux",  "1.0.1"
# github "sequel_pro",  "1.0.1"
# github "virtualbox",  "1.0.13"
# github "chrome",  "1.2.0"
# github "sublime_text",  "1.1.0"
# github "atom",  "1.3.0"
# github "pow",  "2.3.1"
# github "dropbox",  "1.4.1"
# github "iterm2",  "1.2.5.1", :repo => "theand-boxen/puppet-iterm2"
# github "firefox",  "1.2.3.1", :repo => "theand-boxen/puppet-firefox"
# github "hipchat",  "1.1.3"
# github "alfred",  "1.5.0"
# github "ccleaner",  "1.1.1.2", :repo => "theand-boxen/puppet-ccleaner"
# github "fonts",  "0.0.6", :repo => "theand-boxen/puppet-fonts"
# github "mysql_workbench",  "0.0.6", :repo => "theand-boxen/puppet-mysql_workbench"
# github "haroopad",  "0.0.4", :repo => "theand-boxen/puppet-haroopad"
# github "p4merge",  "0.0.7", :repo => "theand-boxen/puppet-p4merge"
# github "brackets",  "0.1.5", :repo => "theand-boxen/puppet-brackets"
# github "sourcetree",  "1.0.4", :repo => "theand-boxen/puppet-sourcetree"
# github "appcleaner",  "1.0.2", :repo => "theand-boxen/puppet-appcleaner"
# github "pgadmin3",  "1.0.2", :repo => "theand-boxen/puppet-pgadmin3"
