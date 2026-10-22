xtdc_vars(){
    COLOR_HEADER='\033[1;36m'
    COLOR_SUCCESS='\033[1;32m'
    COLOR_ERROR='\033[1;31m'
    COLOR_WARNING='\033[1;33m'
    COLOR_INFO='\033[1;34m'
    COLOR_RESET='\033[0m'

    . /etc/os-release 2>/dev/null || true

    case "${ID:-debian}" in
        debian|trixie)
            PKGS=(
                curl wget ca-certificates
                rclone-browser transmission
                smplayer simplescreenrecorder kodi
                shotwell baobab catfish menulibre
                bleachbit evince geany gnome-disk-utility
                gnome-system-monitor gnome-disk-utility gparted
                p7zip-full thunar-archive-plugin synaptic tree xclip
                gvfs-backends gvfs-fuse samba-libs wmctrl
                task-brazilian-portuguese task-gnome-desktop
                fonts-noto fonts-noto-cjk fonts-noto-color-emoji
            )
            ;;
        ubuntu)
            PKGS=(
                rclone-browser transmission
                smplayer simplescreenrecorder kodi
                shotwell baobab catfish menulibre
                bleachbit evince geany gnome-disk-utility
                gnome-system-monitor gnome-system-tools gparted
                p7zip-full thunar-archive-plugin synaptic tree xclip
                gvfs-backends gvfs-fuse samba-libs wmctrl
                task-brazilian-portuguese task-brazilian-portuguese-desktop wbrazilian
            )
            ;;
        *)
            PKGS=(
                curl wget ca-certificates
                rclone-browser transmission
                smplayer simplescreenrecorder
                evince geany gparted
                p7zip-full tree xclip
                gvfs-backends gvfs-fuse
            )
            ;;
    esac

    LIGHTDM_CONF_DIR=""
    if [ -d /usr/share/lightdm ] && [ -d /usr/share/lightdm/lightdm-gtk-greeter.conf.d ]; then
        LIGHTDM_CONF_DIR="/usr/share/lightdm/lightdm-gtk-greeter.conf.d"
    fi

    INSTALL_DIR="/xtdc/appimages"

    LO_URL="https://appimages.libreitalia.org/LibreOffice-still.standard-x86_64.AppImage"
    LO_FILENAME="LibreOffice-still.standard-x86_64.AppImage"
    LO_DESKTOP_FILE="/usr/share/applications/libreoffice-appimage.desktop"

    PINTA_URL="https://github.com/pkgforge-dev/Pinta-AppImage/releases/download/3.1.2-1%402026-07-22_1784722273/Pinta-3.1.2-1-anylinux-x86_64.AppImage"
    PINTA_FILENAME="Pinta.AppImage"
    PINTA_DESKTOP_FILE="/usr/share/applications/pinta.desktop"

    SC_URL="https://github.com/pkgforge-dev/SpeedCrunch-AppImage/releases/download/0.12%402026-07-01_1782912074/SpeedCrunch-0.12-anylinux-x86_64.AppImage"
    SC_FILENAME="SpeedCrunch.AppImage"
    SC_DESKTOP_FILE="/usr/share/applications/speedcrunch.desktop"

    GH_URL="https://github.com/Pinhalito/xtdc/raw/refs/heads/main"
    DOWNLOAD_DIR="/xtdc"
    FILE_LIST=(
        "xtdc_icons.tar.gz"
        "xtdc_theme.tar.gz"
        "xtdc_ttf.tar.gz"
        "xtdc_skel.tar.gz"
        "xtdc"
    )

    PACOTES_REMOVER=(
        aisleriot apport apport-symptoms aspell aspell-en atmel-firmware
        atril atril-common avahi-utils b43-fwcutter bluetooth bluez bluez-firmware
        cheese cheese-common cups-browsed cups-pk-helper debian-faq deja-dup duplicity
        gigolo gnome-characters gnome-font-viewer gnome-initial-setup gnome-logs
        gnome-mahjongg gnome-mines gnome-online-accounts gnome-sudoku gucharmap
        hunspell-en-us libcheese8 libreoffice-calc libreoffice-gtk libreoffice-writer
        mousepad openvpn parole remmina rhythmbox sane-airscan simple-scan
        system-config-printer system-config-printer-common system-config-printer-udev
        thunderbird totem usb-creator-gtk xfburn
        fonts-quicksand fonts-tlwg-garuda fonts-tlwg-kinnari
        fonts-tlwg-laksaman fonts-tlwg-loma fonts-tlwg-mono fonts-tlwg-norasi
        fonts-tlwg-purisa fonts-tlwg-sawasdee fonts-tlwg-typewriter
        fonts-tlwg-typist fonts-tlwg-typo fonts-tlwg-umpush fonts-tlwg-waree
    )
}