#!/bin/bash

set -e

# The mere presence of this file in the home directory disables the system
# copyright notice, the date and time of the last login, the message of the
# day as well as other information that may otherwise appear on login.
# See `man login`.
touch $HOME/.hushlogin

echo 'Install oh-my-zsh'
rm -rf $HOME/.oh-my-zsh
curl -o- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash

echo 'Install powerlevel10k'
POWERLEVEL10K_DIR=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $POWERLEVEL10K_DIR

echo 'Updating configuration...'
# Add global gitignore
rm $HOME/.global-gitignore
ln -s $HOME/dotfiles/shell/.global-gitignore $HOME/.global-gitignore
git config --global core.excludesfile $HOME/.global-gitignore

# Add cURL configuration
rm $HOME/.curlrc
ln -s $HOME/dotfiles/shell/.curlrc $HOME/.curlrc

# Add zsh configuration
rm $HOME/.zshrc
ln -s $HOME/dotfiles/shell/.zshrc $HOME/.zshrc

# Add zsh configuration
rm $HOME/.p10k.zsh
ln -s $HOME/dotfiles/shell/.p10k.zsh $HOME/.p10k.zsh

# Add Mackup configuration
rm $HOME/.mackup.cfg
ln -s $HOME/dotfiles/macos/.mackup.cfg $HOME/.mackup.cfg

echo 'Setup git'
git config --global core.fileMode false
git config --global user.name "Zainal Hasan"
git config --global user.email "19884603+zhanang19@users.noreply.github.com"

echo 'Install homebrew'
if ! command -v brew &> /dev/null
then
  sudo rm -rf /usr/local/Cellar /usr/local/.git
  NONINTERACTIVE=1 curl -o- https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo 'Install zsh plugin'
brew install zsh-autosuggestions

echo 'Instal git credential manager'
brew tap microsoft/git
brew install --cask git-credential-manager-core

echo 'Install rbenv'
brew install rbenv ruby-build

echo 'Install Node JS'
brew install node@16

echo 'Install NVM'
[ -s "$NVM_DIR/nvm.sh" ] || curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

echo 'Install pnpm'
brew install pnpm

echo 'Install pkg-config'
brew install pkg-config

echo 'Install wget'
brew install wget

echo 'Install ack'
brew install ack

echo 'Install php'
brew tap shivammathur/php
brew install shivammathur/php/php@8.1
brew install shivammathur/php/php@8.2
brew link --overwrite --force php@8.2

echo 'Install imagemagick'
brew install imagemagick

echo 'Install imagick'
pecl info imagick || pecl install imagick

echo 'Install memcached'
pecl info memcached || pecl install --configureoptions 'with-zlib-dir="$(brew --prefix zlib)" with-libmemcached-dir="$(brew --prefix libmemcached)" enable-memcached-protocol="no" enable-memcached-sasl="yes" enable-memcached-session="yes" enable-memcached-igbinary="no" enable-memcached-msgpack="no" enable-memcached-json="no" enable-memcached-zstd="no" with-system-fastlz="no"' memcached

echo 'Install redis'
pecl info redis || pecl install --configureoptions 'enable-redis-igbinary="no" enable-redis-lzf="no" enable-redis-zstd="no" enable-redis-msgpack="no" enable-redis-lz4="no"' redis

echo 'Install composer'
if ! command -v composer &> /dev/null
then
  EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

  if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
  then
    >&2 echo 'ERROR: Invalid composer installer checksum'
    rm composer-setup.php
    exit 1
  fi

  php composer-setup.php --quiet
  rm composer-setup.php
  mv composer.phar /usr/local/bin/composer
fi

echo 'Install laravel valet'
composer global require laravel/valet
valet install

echo 'Install mackup'
brew install mackup

echo 'Install some useful QuickLook plugins'
brew install --cask qlstephen quicklook-json qlimagesize qlvideo
brew install --cask quicklook-csv webpquicklook

echo 'Install Visual Studio Code'
brew install --cask visual-studio-code

echo 'Install Sublime Text'
brew install --cask sublime-text

echo 'Install iTerm2'
brew install --cask iterm2

echo 'Install Firefox'
brew install --cask firefox

echo 'Install Raycast'
brew install --cask raycast

echo 'Install Tableplus'
brew install --cask tableplus

echo 'Install Zappy'
brew install --cask zappy

echo 'Install Dozer'
brew install --cask dozer

echo 'Install Itsycal'
brew install --cask itsycal

echo 'Install KeyboardCleanTool'
brew install --cask keyboardcleantool

echo 'Install AppCleaner'
brew install --cask appcleaner

echo 'Install Camo Studio'
brew install --cask camo-studio

echo 'Install The Unarchiver'
brew install --cask the-unarchiver

echo 'Install font to ensure terminal displayed correctly'
cp -vf "fonts/Droid Sans Mono for Powerline.otf" "$HOME/Library/Fonts/"
cp -vf "fonts/Menlo-Powerline.otf" "$HOME/Library/Fonts/"

echo 'All done!'

echo 'There is some application that need to installed manually!'

echo 'Download Figmac'
open "https://figmac.com/download/Figmac.zip"

echo ''
echo ''
echo 'Additional steps:'
echo '1. Open and sync Dropbox folder'
echo '2. Run `mackup restore` to setting up your preferences'
echo '3. Setting up terminal and zsh theme-color'
echo '4. Setting up default behaviour for OSX using command `cd macos && bash defaults-osx.sh`'
echo '5. Create a custom file in `dotfiles-custom/shell/.aliases` for your custom command aliases'
echo ''

