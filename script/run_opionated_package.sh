#!/bin/bash


source /opt/boxen/env.sh

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###### Brew update&upgrade
brew update --force
brew upgrade
brew tap homebrew/versions
brew tap caskroom/fonts
brew tap caskroom/versions
brew tap caskroom/drivers

###### these package needs admin's password during installation.
CASK_SUDO_PACKAGES=(
  duet
  logitech-unifying
)

for i in ${CASK_SUDO_PACKAGES[@]};
do
    brew cask install "$i";
done


###### Brew Packages with options



###### Brew Packages
BREW_PACKAGES=(
  ansible
  caddy
  cloc
  exif
  exiftags
  ffmpeg
  freetype
  libxml2
  libyaml
  testssl
  typescript
  x264
  xvid
)

for i in ${BREW_PACKAGES[@]};
do
    brew install "$i";
done


####### Cask

CASK_PACKAGES=(
  beyond-compare
  day-o
  google-photos-backup-and-sync
  handbrake
  haroopad
  libreoffice
  macdown
  marp
  mojibar
  ngrok
  ransomwhere
  rescuetime
  scroll-reverser
  steam
  timings
  vagrant-manager
  vmware-fusion
  wordpresscom
  xnviewmp
  xtrafinder
)

for i in ${CASK_PACKAGES[@]};
do
    brew cask install "$i";
done


####### FONTS




###### After installation script
brew config
brew list
brew cask list
brew cleanup


###### Switch to using brew-installed bash as default shell

