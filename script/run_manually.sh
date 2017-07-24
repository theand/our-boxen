#!/bin/bash


source /opt/boxen/env.sh

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###### Brew update&upgrade
brew update --force
brew upgrade
brew tap caskroom/fonts
brew tap caskroom/versions
brew tap caskroom/drivers

###### these package needs admin's password during installation.
CASK_SUDO_PACKAGES=(
  java
  alfred
  bettertouchtool
  dash3
  docker
  gureumkim
  vagrant
  virtualbox
)

for i in ${CASK_SUDO_PACKAGES[@]};
do
    brew cask install "$i";
done


###### Brew Packages with options
brew install vim --with-lua --with-override-system-vi --force
brew cask install macvim --with-lua


###### Brew Packages
BREW_PACKAGES=(
  ack
  autoconf
  autojump
  automake
  bash
  bash-completion2
  ccat
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
  grep
  icdiff
  imagemagick
  mackup
  maven
  moreutils
  node
  openssl
  privoxy
  recode
  ssh-copy-id
  the_silver_searcher
  tmux
  tomcat
  tree
  w3m
  wget
  yarn
)

for i in ${BREW_PACKAGES[@]};
do
    brew install "$i";
done


####### Cask

CASK_PACKAGES=(
  appcleaner
  atom
  ccleaner
  dropbox
  evernote
  firefox
  flux
  google-chrome
  google-backup-and-sync
  hyper
  jetbrains-toolbox
  malwarebytes-anti-malware
  mysqlworkbench
  opera
  p4merge
  pgadmin4
  scroll-reverser
  slack
  sourcetree
  switchresx
  telegram-desktop
  visual-studio-code
  vmware-horizon-client
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


###### Switch to using brew-installed bash as default shell
if ! fgrep -q '/usr/local/bin/bash' /etc/shells; then
  echo '/usr/local/bin/bash' | sudo tee -a /etc/shells;
  chsh -s /usr/local/bin/bash;
  sudo chsh -s /usr/local/bin/bash;
fi;


pip install --upgrade pip setuptools

/usr/local/bin/bash ~/mathiasdotfiles/bootstrap.sh

#curl https://github.com/theand/spf13-vim/raw/theand/bootstrap.sh -L | bash -s

/usr/local/bin/bash ~/mathiasdotfiles/.macos
