#!/bin/bash

# The mere presence of this file in the home directory disables the system
# copyright notice, the date and time of the last login, the message of the
# day as well as other information that may otherwise appear on login.
# See `man login`.
touch $HOME/.hushlogin

echo 'Install oh-my-zsh'
rm -rf $HOME/.oh-my-zsh
curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh

echo 'Install some zsh plugin'
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

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

# Add Mackup configuration
rm $HOME/.mackup.cfg
ln -s $HOME/dotfiles/macos/.mackup.cfg $HOME/.mackup.cfg

echo 'Install composer'
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

echo 'Install homebrew'
sudo rm -rf /usr/local/Cellar /usr/local/.git && brew cleanup
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo 'Install Node JS'
brew install node@16

echo 'Install NVM'
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

echo 'Install pkg-config'
brew install pkg-config

echo 'Install wget'
brew install wget

echo 'Install ack'
brew install ack

echo 'Install brew-cask'
brew tap homebrew/cask-cask
brew install brew-cask

echo 'Install php 7.* versions'
brew tap shivammathur/php
brew install shivammathur/php/php@7.2
brew install shivammathur/php/php@7.4
brew install shivammathur/php/php@8.1

echo 'Install imagemagick'
brew install imagemagick

echo 'Install imagick'
pecl install imagick

echo 'Install memcached'
pecl install memcached

echo 'Install xdebug'
pecl install xdebug

echo 'Install redis'
pecl install redis

echo 'Install laravel valet'
composer global require laravel/valet
valet install

echo 'Install mackup'
brew install mackup

echo 'Install some useful QuickLook plugins'
brew install --cask qlcolorcode qlstephen qlmarkdown quicklook-json qlimagesize qlvideo
brew install --cask quicklook-csv webpquicklook

echo 'Install Visual Studio Code'
brew install --cask visual-studio-code

echo 'Install Sublime Text'
brew install --cask sublime-text

echo 'Install Github'
brew install --cask github

echo 'Install Firefox'
brew install --cask firefox

echo 'Install Anydesk'
brew install --cask anydesk

echo 'Install WhatsApp'
brew install --cask whatsapp

echo 'Install Bitwarden'
brew install --cask bitwarden

echo 'Install Raycast'
brew install --cask raycast

echo 'Install Tableplus'
brew install --cask tableplus

echo 'Install Dropbox'
brew install --cask dropbox

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

echo 'Install Dracula theme for Terminal'
brew tap dracula/install
brew install --cask dracula-terminal

echo 'Install font to ensure terminal displayed correctly'
cp -vf "fonts/Droid Sans Mono for Powerline.otf" "$HOME/Library/Fonts/"
cp -vf "fonts/Menlo-Powerline.otf" "$HOME/Library/Fonts/"

echo 'Instal custom agnoster theme'
ln -s "shell/zsh-theme/agnoster.zsh-theme" "$ZSH/custom/themes/"

echo 'All done!'

echo 'There is some application that need to installed manually!'

echo 'Download Figmac'
open "https://figmac.com/download/Figmac.zip"

# echo 'Install Lightshot Screenshot'
# open "https://apps.apple.com/us/app/lightshot-screenshot/id526298438"

echo ''
echo ''
echo 'Additional steps:'
echo '1. Open and sync Dropbox folder'
echo '2. Run `mackup restore` to setting up your preferences'
echo '3. Setting up terminal and zsh theme-color'
echo '4. Setting up default behaviour for OSX using command `cd macos && bash defaults-osx.sh`'
echo '5. Create a custom file in `dotfiles-custom/shell/.aliases` for your custom command aliases'
echo ''

