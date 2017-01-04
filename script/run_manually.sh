#!/bin/bash


set -euo pipefail


# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &


###### Switch to using brew-installed bash as default shell
if ! fgrep -q '/usr/local/bin/bash' /etc/shells; then
  echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
  chsh -s /usr/local/bin/bash;
fi;


###### Brew update&upgrade
mv /usr/local/Homebrew /usr/local/_BACKUP_Homebrew
brew update --force
brew upgrade
brew tap homebrew/versions
brew tap caskroom/fonts

###### these package needs admin's password during installation.
CASK_SUDO_PACKAGES=(
  java
  alfred
  bettertouchtool
  docker
  gureumkim
  vagrant
  virtualbox
  dash
)

for i in ${CASK_SUDO_PACKAGES[@]};
do
    brew cask install "$i";
done


###### Brew Packages with options
brew install vim --with-lua --override-system-vi
brew cask install macvim --with-cscope --with-lua
brew linkapps macvim


###### Brew Packages
BREW_PACKAGES=(
  ack
  autojump
  automake
  bash
  homebrew/versions/bash-completion2
  cmake
  coreutils
  ctags
  dos2unix
  findutils
  fzf
  git-flow
  git-lfs
  gnu-sed
  gnu-tar
  gradle
  icdiff
  imagemagick
  maven
  moreutils
  node
  openssl
  privoxy
  ssh-copy-id
  the_silver_searcher
  tmux
  tomcat
  tree
  wget
)

for i in ${BREW_PACKAGES[@]};
do
    brew install "$i";
done


####### Cask

CASK_PACKAGES=(
  appcleaner
  appdelete
  atom
  ccleaner
  dropbox
  evernote
  firefox
  flux
  google-chrome
  google-drive
  hyper
  macdown
  malwarebytes-anti-malware
  mysqlworkbench
  opera
  p4merge
  pgadmin4
  rescuetime
  scroll-reverser
  slack
  sourcetree
  switchresx
  telegram-desktop
  vmware-horizon-client
  yarn
)

for i in ${CASK_PACKAGES[@]};
do
    brew cask install "$i";
done


####### FONTS

FONT_PACKAGES=(
  font-anonymous-pro
  font-d2coding
  font-fira-code
  font-hermit
  font-inconsolata
  font-nanumgothic
  font-nanumgothiccoding
  font-nanummyeongjo
  font-noto-mono
  font-noto-sans-cjk-kr
  font-roboto
  font-roboto-mono
  font-source-code-pro
)

for i in ${FONT_PACKAGES[@]};
do
    brew cask install "$i";
done





###### After installation script
brew config
brew list
brew cask list
brew cleanup

pip install --upgrade pip setuptools

source ~/mathiasdotfiles/bootstrap.sh

/usr/local/opt/fzf/install

source ~/mathiasdotfiles/.macos
