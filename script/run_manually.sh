#!/bin/bash


# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

brew update;
brew upgrade;

###### Brew

BREW_PACKAGES=(
ack
autojump
automake
bash
bash-completion2
cmake
ctags
dos2unix
findutils
fzf
git-flow
git-lfs
gnu-sed
gnu-tar
icdiff
imagemagick
moreutils
node
openssl
privoxy
ssh-copy-id
the_silver_searcher
tmux
tree
vim
wget
)

for i in ${BREW_PACKAGES[@]};
do
    brew install $i;
done



####### Cask
CASK_PACKAGES=(
appcleaner
appdelete
atom
ccleaner
dropbox
duet
evernote
firefox
flux
google-chrome
google-drive
macdown
malwarebytes-anti-malware
mysqlworkbench
near-lock
opera
p4merge
pgadmin4
scroll-reverser
slack
sourcetree
telegram-desktop
vmware-horizon-client
)


for i in ${CASK_PACKAGES[@]};
do
    brew cask install $i;
done



###### these package needs admin's password during installation.

brew cask install java
brew install tomcat
brew install maven
brew install gradle

brew cask install alfred
brew cask install bettertouchtool
brew cask install docker
brew cask install gureumkim
brew cask install macvim
brew cask install vagrant
brew cask install virtualbox
brew cask install xtrafinder
brew cask install dash
