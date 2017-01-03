#!/bin/bash


# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until this script has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###### Brew update&upgrade
mv /usr/local/Homebrew /usr/local/_BACKUP_Homebrew
brew update --force
brew upgrade
brew doctor


###### Brew Packages

BREW_PACKAGES=(
ack
autojump
automake
bash
homebrew/versions/bash-completion2
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

CASK_SUDO_PACKAGES=(
java
alfred
bettertouchtool
docker
gureumkim
macvim
vagrant
virtualbox
xtrafinder
dash
)

for i in ${CASK_SUDO_PACKAGES[@]};
do
    brew cask install $i;
done


###### java dependency

brew install tomcat
brew install maven
brew install gradle


###### After installation script
brew config
pip install --upgrade pip setuptools
/usr/local/opt/fzf/install
