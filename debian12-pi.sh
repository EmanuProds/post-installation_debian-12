#!/bin/bash
#
# Facilitate post installation Debian in minutes personalizated.
#
# Website:       https://debian.org/
# Author:        Emanuel Pereira
# Maintenance:   Emanuel Pereira
#
# ------------------------------------------------------------------------ #
# WHAT IT DOES?
# This script can be called by the normal way using "./".
#
# CONFIGURATION?
# I recommend that you open it in your favorite text editor and customize it with whatever packages you want.
#
# HOW TO USE IT?
# Examples:
# $ ./debian12-pi.sh
#
# ------------------------------------------------------------------------ #
# Changelog:
#
#   v1.5 05/09/2023, Emanuel Pereira:
#     - Initial release
#
# ------------------------------------------------------------------------ #
# Tested on:
#   bash 5.2.15(1)-release
# ------------------------------------------------------------------------ #
DIRETORY_TEMP='$HOME/.d12pi/'
DIRETORY_DOWNLOAD='$HOME/Downloads/'

create_temporary_post_install_folder () {
	if [[ ! -d "$DIRETORY_TEMP" ]]; then
	mkdir .tmp
	fi
	cd .tmp
}
remove_preinstalled_apps () {
	sudo apt purge gnome-music gnome-nibbles gnome-mines gnome-maps gnome-mahjongg gnome-klotski gnome-2048 gnome-chess gnome-contacts gnome-games gnome-robots gnome-sudoku gnome-taquin gnome-tetravex anthy anthy-common evolution evolution-common goldendict hdate mlterm mlterm-common mlterm-tools mozc-data mozc-server mozc-utils-gui rhythmbox rhythmbox-data rhythmbox-plugin-cdrecorder rhythmbox-plugins thunderbird thunderbird-l10n-ja xiterm+thai xfonts-thai xfonts-thai-etl xfonts-thai-manop xfonts-thai-nectec xfonts-thai-poonlap xfonts-thai-vor firefox-esr-l10n-* -y
}
update_system () {
	sudo apt update; sudo apt upgrade -y
}
edit_repository-sources () {
	sudo nano /etc/apt/sources.list
# edit like this:
##  See https://wiki.debian.org/SourcesList for more information.
# deb http://deb.debian.org/debian bookworm main non-free-firmware contrib non-free
# deb-src http://deb.debian.org/debian bookworm main non-free-firmware contrib non-free
# 
# deb http://deb.debian.org/debian bookworm-updates main non-free-firmware contrib non-free
# deb-src http://deb.debian.org/debian bookworm-updates main non-free-firmware contrib non-free
# 
# deb http://security.debian.org/debian-security/ bookworm-security main non-free-firmware contrib non-free
# deb-src http://security.debian.org/debian-security/ bookworm-security main non-free-firmware contrib non-free
# 
## Backports allow you to install newer versions of software made available for this release
# deb http://deb.debian.org/debian bookworm-backports main non-free-firmware contrib non-free
# deb-src http://deb.debian.org/debian bookworm-backports main non-free-firmware contrib non-free
}
install_necessary_sources () {
	sudo dpkg --add-architecture i386 ; sudo apt update ; sudo apt upgrade
	sudo apt install msttcorefonts firefox-esr-l10n-pt-br firmware-linux firmware-amd-graphics wget git gnome-shell-extension-manager  -y
}
install_visual-studio-code () {
	cd DIRETORY_TEMP
	wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
	sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
	sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
	sudo apt update ; sudo apt install code -y
}
