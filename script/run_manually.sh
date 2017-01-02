#!/bin/bash

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


# these package needs admin's password during installation.

brew cask install java
brew install tomcat
brew install maven
brew install gradle

brew cask install alfred
#brew cask install atom
brew cask install bettertouchtool
brew cask install docker
brew cask install gureumkim
brew cask install macvim
brew cask install vagrant
brew cask install virtualbox
brew cask install xtrafinder
brew cask install dash
