#!/usr/bin/env bash
#
#######################
#    ^...^  `^...^´   #
#   / o,o \ / O,O \   #
#   |):::(| |):::(|   #
# ====" "=====" "==== #
#         TdC         #
#      1998-2026      #
#######################
#
# Toca das Corujas
# Códigos Binários,
# Funções de Onda e
# Teoria do Orbital Molecular Inc.
# Unidade Barão Geraldo CX
#
# 2026_10_30_18_10_37

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "Este script precisa ser executado como root. Tente: sudo $0"
    exit 1
fi


apt update
apt full-upgrade -y


apt install --no-install-recommends adwaita-qt baobab bleachbit catfish dbus-x11 evince \
  file-roller firmware-amd-graphics geany gparted libxfce4ui-utils \
  lightdm lightdm-gtk-greeter p7zip-full qt5ct shotwell \
  simplescreenrecorder synaptic thunar thunar-archive-plugin transmission \
  vlc wbrazilian wmctrl xclip xfce4-appfinder xfce4-panel \
  xfce4-pulseaudio-plugin xfce4-session xfce4-settings xfce4-terminal \
  xfce4-whiskermenu-plugin xfconf xfdesktop4 xfwm4


# Devuan com sysvinit: habilita o LightDM para iniciar no próximo boot.
update-rc.d lightdm defaults


apt autoclean
apt autoremove

echo "Instalação concluída. Reinicie para iniciar o XFCE com LightDM."




