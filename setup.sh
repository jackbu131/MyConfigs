#!/bin/bash

# Sets up the environment as if after a fresh install
# Intended to use on Ubuntu 17.04+ or Mac OS X High Sierra

isOsx() {
	[ `uname` == "Darwin" ]
}

isLinux() {
	[ `uname` == "Linux" ]
}

title() {
	echo
	echo "~~~ $1 ~~~"
}

listItem() {
	echo " - $1"
}

linkItem() {
	if [[ ! -e $2 ]] ; then
		listItem "$1"
		linkDir=$(dirname $2)
		mkdir -p "$linkDir"
		ln -s $(pwd)/$3 $2
	fi
}

title "Making default dirs"
mkdir -p ~/.local/npm-global ~/dev ~/workspace ~/science

if `isOsx` ; then
	title "Installing Homebrew"
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	export PATH=/usr/local/bin:/usr/local/sbin:$PATH
else
	title "Updating packages cache"
	sudo apt update

	title "Upgrading installed packages"
	sudo apt upgrade --assume-yes
fi

title "Installing OS packages"
if `isOsx` ; then
	brew install node yarn
else
	sudo apt install --assume-yes xsel git zsh scrot python3 pinta pavucontrol curl blueman

	if ! hash node 2>/dev/null; then
		title "Installing NodeJS"
		curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
		sudo apt install --assume-yes nodejs
	fi

fi

title "Setting symlinks"
linkItem "Fonts directory"                            ~/.fonts                           "fonts"

#linkItem "tmux configuration"                         ~/.config/tmux/config              "dotfiles/tmux.conf"
linkItem "Git configuration (1/3)"                    ~/.gitconfig                       "dotfiles/gitconfig"
linkItem "Git configuration (2/3)"                    ~/.gitignore                       "dotfiles/gitignore"
linkItem "Git configuration (3/3)"                    ~/dev/.gitconfig                   "dotfiles/work-gitconfig"
linkItem "Zsh configuration"                          ~/.zshrc                           "dotfiles/zshrc"
linkItem "NPM configuration"                          ~/.npmrc                           "dotfiles/npmrc"

if `isOsx` ; then
	defaults write -g com.apple.swipescrolldirection -bool FALSE
fi
