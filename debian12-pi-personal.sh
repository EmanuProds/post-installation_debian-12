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
#   v1.6 14/09/2023, Emanuel Pereira:
#     - Code update
#	  - Bugs fixes
#
# ------------------------------------------------------------------------ #
# Tested on:
#   bash 5.2.15(1)-release
# ------------------------------------------------------------------------ #
remove_preinstalled_desnecessary_apps () {
	sudo apt purge seahorse im-config transmission-gtk transmission-common xterm hdate-applet shotwell shotwell-common swell-foop aisleriot atomix five-or-more hitori iagno lightsoff four-in-a-row tali gnome-music gnome-nibbles gnome-mines gnome-maps gnome-mahjongg gnome-klotski gnome-2048 gnome-chess gnome-contacts gnome-games gnome-robots gnome-sudoku gnome-taquin gnome-tetravex anthy anthy-common evolution evolution-common goldendict hdate mlterm mlterm-common mlterm-tools mozc-data mozc-server mozc-utils-gui rhythmbox rhythmbox-data rhythmbox-plugin-cdrecorder rhythmbox-plugins thunderbird thunderbird-l10n-ja xiterm+thai xfonts-thai xfonts-thai-etl xfonts-thai-manop xfonts-thai-nectec xfonts-thai-poonlap xfonts-thai-vor firefox-esr-l10n-* -y
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
	sudo apt install mesa-vulkan-drivers libglx-mesa0:i386 mesa-vulkan-drivers:i386 libgl1-mesa-dri:i386 -y
	sudo apt install default-jre bluez-cups gtklp system-config-printer printer-driver-escpr printer-driver-gutenprint printer-driver-hpcups printer-driver-hpijs adb unrar flatpak gnome-software-plugin-flatpak ufw gufw msttcorefonts firefox-esr-l10n-pt-br firmware-linux firmware-amd-graphics wget git gnome-shell-extension-manager -y
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}
install_themes () {
	wget -qO- https://git.io/papirus-icon-theme-install | sh
	wget -qO- https://git.io/papirus-folders-install | sh
	papirus-folders -C yellow --theme Papirus
	sudo cp -r src/Modelos ~/
	sudo cp -r src/cursors/simp1e-mix-dark /usr/share/icons
	sudo cp -r src/cursors/simp1e-mix-light /usr/share/icons
	sudo cp -r src/boot/grub-4x3.png /usr/share/desktop-base/active-theme/grub
	sudo cp -r src/boot/grub-16x9.png /usr/share/desktop-base/active-theme/grub
	sudo cp -r src/boot/grub_background.sh /usr/share/desktop-base/active-theme/grub
	sudo cp -r src/themes/adw-gtk3 /usr/share/themes
	sudo cp -r src/themes/adw-gtk3-dark /usr/share/themes
	cd ~/Downloads/src
	sudo apt install plymouth -y
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
	sudo apt install grub-customizer -y
	grub-customizer
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
	sudo systemctl edit --full systemd-fsck-root.service
# add below ExecStart:
# 	StandardOutput=null
# 	StandardError=journal+console
	sudo systemctl edit --full systemd-fsck@.service
# add below ExecStart:
#   	StandardOutput=null
#	StandardError=journal+console
#
	sudo cp -r simplefuture/ /usr/share/plymouth/themes/
	sudo plymouth-set-default-theme -R simplefuture --rebuild-initrd
	extension-manager
# after installing the "Extension Manager", install your favorites extensions.
#
#	Alphabetical Grid Extension
#	Appindicator
#	Arcmenu 
#	Awesome Tiles
#	Bluetooth-quick-connect
#	Caffeine
#	Color Picker
#	Custom Accent Colors
#	Dash-to-dock
#	Gnome 4x UI Improvements
#	Gsconnect 
#	GTK Title Bar 
#	Just Perfection
#	Panel-corners
#	Rounded-window-corners
#	X11 Gestures (need install Touchegg)
#	[QSTweak] Quick Settings Tweaker 
}
remove_startup_beep () {
	sudo rmmod pcspkr
	sudo nano /etc/modprobe.d/nobeep.conf
# add "blacklist pcspkr" in end-line.
	sudo nano /etc/sysctl.d/20-quiet-printk.conf
# add "kernel.printk = 3 3 3 3" in end-line.
}
install_qt5ct_qt6ct () {
	sudo apt install qt5ct qt6ct adwaita-qt adwaita-qt6 -y
	sudo nano /etc/environment
	qt5ct
	qt6ct
# add "QT_QPA_PLATFORMTHEME=qt5ct" in end-line.
}
install_visual-studio-code () {
	cd ~/Downloads/post-installation_debian-12
	wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
	sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
	sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
	sudo apt update ; sudo apt install code -y
}
install_apps_optional () {
	flatpak install flathub app/org.videolan.VLC/x86_64/stable app/io.github.Foldex.AdwSteamGtk app/com.github.unrud.VideoDownloader app/com.obsproject.Studio app/org.gimp.GIMP app/org.inkscape.Inkscape app/com.github.tchx84.Flatseal app/app.drey.Dialect app/com.heroicgameslauncher.hgl app/com.github.neithern.g4music app/org.audacityteam.Audacity app/org.kde.kdenlive app/org.telegram.desktop app/de.shorsh.discord-screenaudio app/com.valvesoftware.Steam app/com.bitwarden.desktop app/net.lutris.Lutris app/org.duckstation.DuckStation app/net.pcsx2.PCSX2 app/org.yuzu_emu.yuzu app/io.mgba.mGBA app/net.brinkervii.grapejuice app/com.usebottles.bottles/x86_64/stable app/io.github.realmazharhussain.GdmSettings app/com.carpeludum.KegaFusion app/com.snes9x.Snes9x app/org.DolphinEmu.dolphin-emu app/net.veloren.airshipper app/com.microsoft.Edge app/com.vysp3r.ProtonPlus -y
}
install_zsh () {
	cd /usr/local/share/fonts
	sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
	sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
	sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
	sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
	sudo apt install git zsh zsh-autosuggestions zsh-syntax-highlighting fzf -y
	cd ~/Downloads/post-installation_debian-12
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
	cd
	sudo rm -Rf ~/Downloads/post-installation_debian-12
	exit
}
#------------------------------------------------------------------------ #
# Commands (uncomment the ones you want to use)
#------------------------------------------------------------------------ #
remove_preinstalled_desnecessary_apps
update_system
edit_repository-sources
install_necessary_sources
install_themes
remove_startup_beep
install_qt5ct_qt6ct
install_visual-studio-code
install_apps_optional
install_zsh
alias_bash
#SSD_NVME-boost
finalization