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

github "boxen", "3.12.0.theand", :repo => "theand-boxen/puppet-boxen"

# Support for default hiera data in modules

github "module_data", "0.0.4", :repo => "ripienaar/puppet-module-data"

# Core modules for a basic development environment. You can replace
# some/most of these if you want, but it's not recommended.


github "brewcask",    "0.0.10.theand", :repo => "theand-boxen/puppet-brewcask"
github "git",         "2.13.0"
github "homebrew",    "2.1.0.4.theand", :repo => "theand-boxen/puppet-homebrew"
github "inifile",     "1.6.0", :repo => "puppetlabs/puppetlabs-inifile"
github "pkgconfig",   "1.0.0"
github "repository",  "2.4.1"
github "stdlib",      "4.17.1", :repo => "puppetlabs/puppetlabs-stdlib"
github "sudo",        "1.0.0"
github "xquartz",    "1.2.1.theand", :repo => "theand-boxen/puppet-xquartz"

# Optional/custom modules. There are tons available at
# https://github.com/boxen.

# custom Dev Tools by theand
github "python",  "3.1.0", :repo => "mloberg/puppet-python"
github "ruby",        "8.5.7.1.theand", :repo => "theand-boxen/puppet-ruby"
github "spf13vim3",  "1.0.2.theand", :repo => "theand-boxen/puppet-spf13vim3"


# custom Default OS X Settings by theand
github "osx",  "2.8.0"
github "mathiasdotfiles",  "0.0.2.theand", :repo => "theand-boxen/puppet-mathiasdotfiles"

# custom GUI Apps by theand
github "sublime_text",  "1.1.1"
github "iterm2",  "1.2.5.2.theand", :repo => "theand-boxen/puppet-iterm2"
