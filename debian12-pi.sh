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

create_temporary_post_install_folder () {
	if [[ ! -d "$DIRETORY_TEMP" ]]; then
	mkdir .d12pi
	fi
	cd .d12pi
}
remove_preinstalled_desnecessary_apps () {
	sudo apt purge swell-foop aisleriot atomix five-or-more hitori iagno lightsoff four-in-a-row tali gnome-music gnome-nibbles gnome-mines gnome-maps gnome-mahjongg gnome-klotski gnome-2048 gnome-chess gnome-contacts gnome-games gnome-robots gnome-sudoku gnome-taquin gnome-tetravex anthy anthy-common evolution evolution-common goldendict hdate mlterm mlterm-common mlterm-tools mozc-data mozc-server mozc-utils-gui rhythmbox rhythmbox-data rhythmbox-plugin-cdrecorder rhythmbox-plugins thunderbird thunderbird-l10n-ja xiterm+thai xfonts-thai xfonts-thai-etl xfonts-thai-manop xfonts-thai-nectec xfonts-thai-poonlap xfonts-thai-vor firefox-esr-l10n-* -y
	sudo apt auto-remove -y
}
update_system () {
	sudo apt update; sudo apt upgrade -y
}
edit_repository-sources () {
	sudo nano /etc/apt/sources.list
# edit like this:
## See https://wiki.debian.org/SourcesList for more information.
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
	sudo dpkg --add-architecture i386 ; sudo apt update ; sudo apt upgrade -y
	sudo apt install flatpak gnome-software-plugin-flatpak ufw gufw msttcorefonts firefox-esr-l10n-pt-br firmware-linux firmware-amd-graphics wget git gnome-shell-extension-manager -y
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}
install_themes () {
	cd DIRETORY_TEMP
	wget -qO- https://git.io/papirus-icon-theme-install | sh
	wget -qO- https://git.io/papirus-folders-install | sh
	papirus-folders -C yellow --theme Papirus
	cp src/cursors/simp1e-mix-dark ~/.icons
	cp src/cursors/simp1e-mix-light ~/.icons
	sudo cp -r src/grub-4x3.png /usr/share/desktop-base/active-theme/grub
	sudo cp -r src/grub-16x9.png /usr/share/desktop-base/active-theme/grub
	sudo cp -r src/grub_background.sh /usr/share/desktop-base/active-theme/grub
	git clone https://github.com/volkavich/simplefuture
	sudo apt install plymouth
	sudo nano /etc/default/grub
# edit like this:
#
# GRUB_DEFAULT="0"
# GRUB_TIMEOUT="0"
# GRUB_RECORDFAIL_TIMEOUT="$GRUB_HIDDEN_TIMEOUT"
# GRUB_DISTRIBUTOR="`lsb_release -i -s 2> /dev/null || Debian`"
# GRUB_CMDLINE_LINUX_DEFAULT="quiet splash loglevel=0 bgrt_disable rd.systemd.show_status=auto rd.udev.log_priority=0 vt.global_cursor_default=0 vga=current"
# GRUB_CMDLINE_LINUX=""
#
# GRUB_DISABLE_OS_PROBER="true"
# GRUB_TIMEOUT_STYLE="hidden"
# GRUB_HIDDEN_TIMEOUT="0"
#
# GRUB_GFXMODE="1920x1080"
	sudo update-grub
	sudo update-grub2
	sudo nano /etc/initramfs-tools/modules
# edit like this for Intel:
# # KMS
# intel_agp
# drm
# i915 modeset=1
#
# For Nouveau (nVidia):
# # KMS
# drm
# nouveau modeset=1
#
# For Radeon (old amd gpu's):
# # KMS
# drm
# radeon modeset=1
#
# For AMDGPU:
# # KMS
# drm
# amdgpu modeset=1
	sudo update-initramfs -u 
	cp -r simplefuture/ /usr/share/plymouth/themes/
	plymouth-set-default-theme -R simplefuture --rebuild-initrd 
# put the apps you want to install together here.
# after installing the "Extension Manager", install your favorites extensions.
#
#	Alphabetical Grid Extension
#	Appindicator
#	Arc-menu 
#	Arch Update
#	Bluetooth-quick-connect
#	Dash-to-dock
#	Gsconnect 
#	GTK Title Bar 
#	Just Perfection
#	Caffeine
#	Color Picker
#	Custom Accent Colors
#	Gnome 4x UI Improvements
#	Panel-corners
#	[QSTweak] Quick Settings Tweaker 
#	Rounded-window-corners
#	Awesome Tiles
}
install_google-chrome () {
	sudo apt purge firefox-esr firefox-esr-l10n-* -y
	flatpak install app/com.google.Chrome/x86_64/stable -y
}
install_visual-studio-code () {
	cd DIRETORY_TEMP
	wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
	sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
	sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
	sudo apt update ; sudo apt install code -y
}
install_apps_optional () {
#	flatpak install io.github.Foldex.AdwSteamGtk com.github.unrud.VideoDownloader com.obsproject.Studio org.gimp.GIMP org.inkscape.Inkscape com.github.tchx84.Flatseal app.drey.Dialect com.heroicgameslauncher.hgl com.github.neithern.g4music org.audacityteam.Audacity org.kde.kdenlive com.anydesk.Anydesk org.telegram.desktop de.shorsh.discord-screenaudio com.valvesoftware.Steam com.bitwarden.desktop net.lutris.Lutris org.duckstation.DuckStation net.pcsx2.PCSX2 org.yuzu_emu.yuzu io.mgba.mGBA net.brinkervii.grapejuice app/com.usebottles.bottles/x86_64/stable io.github.realmazharhussain.GdmSettings com.carpeludum.KegaFusion com.snes9x.Snes9x org.DolphinEmu.dolphin-emu net.veloren.airshipper com.microsoft.Edge com.vysp3r.ProtonPlus -y
#	flatpak install org.telegram.desktop com.github.eneshecan.WhatsAppForLinux
}
install_zsh () {
	cd /usr/local/share/fonts
	sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
	sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
	sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
	sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
	sudo apt install git zsh zsh-autosuggestions zsh-syntax-highlighting fzf -y
	cd DIRETORY_TEMP
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
	cp -r src/terminal/.zshrc ~/
	cp -r src/terminal/.zsh-aliases ~/
}
alias_bash () {
	cp -r src/terminal/.bash-aliases ~/
}
SSD_NVME-boost () {
	sudo su -
	echo "vm.vfs_cache_pressure=50" >> /etc/sysctl.conf
	echo "vm.dirty_background_ratio = 5" >> /etc/sysctl.conf
}
finalization () {
	sudo rm -Rf /.d12pi
	echo 'finalizado!!! :D'
}