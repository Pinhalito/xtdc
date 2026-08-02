#!/bin/bash
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
# 2026_08_02_12_19_20

xtdc_vars(){
    COLOR_HEADER='\033[1;36m'
    COLOR_SUCCESS='\033[1;32m'
    COLOR_ERROR='\033[1;31m'
    COLOR_WARNING='\033[1;33m'
    COLOR_INFO='\033[1;34m'
    COLOR_RESET='\033[0m'

    PKGS=(
        rclone-browser transmission
        smplayer simplescreenrecorder kodi
        shotwell 
        baobab clipit file-roller catfish menulibre
        bleachbit evince geany gnome-disk-utility 
        gnome-system-monitor gnome-system-tools gparted
        p7zip-full rar unrar thunar-archive-plugin
        speedcrunch synaptic tree xclip
        gvfs-backends gvfs-fuse samba-libs wmctrl
        task-brazilian-portuguese task-brazilian-portuguese-desktop wbrazilian
    )

    # Google Chrome / Brave extensões
    CHROME_EXT_DIR="/opt/google/chrome/extensions"
    declare -A CHROME_EXT=(
        ["ponfpcnoihfmfllpaingbgckeeldkhle"]="Enhancer for YouTube"
        ["mnjggcdmjocbbbhaepdhchncahnbgone"]="SponsorBlock para YouTube"
        ["aapbdbdomjkkjkaonfhkkikfgjllcleb"]="Google Tradutor"
        ["gbkeegbaiigmenfmjfclcdgdpimamgkj"]="Editor do Office"
    )

    BRAVE_EXT_DIR="/opt/brave.com/brave/extensions"
    declare -A BRAVE_EXT=(
        ["ponfpcnoihfmfllpaingbgckeeldkhle"]="Enhancer for YouTube"
        ["mnjggcdmjocbbbhaepdhchncahnbgone"]="SponsorBlock para YouTube"
    )

    # AppImage
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
    
    # Tema LightDM
    LIGHTDM_CONF_DIR="/usr/share/lightdm/lightdm-gtk-greeter.conf.d"

    # Downloads do repositório
    GH_URL="https://github.com/Pinhalito/xtdc/raw/refs/heads/main"
    DOWNLOAD_DIR="/xtdc"
    FILE_LIST=(
        "xtdc_icons.tar.gz"
        "xtdc_theme.tar.gz"
        "xtdc_ttf.tar.gz"
        "xtdc_skel.tar.gz"
        "xtdc"
    )

    REQUIRED_FILES=(
        "xtdc_icons.tar.gz"
        "xtdc_theme.tar.gz"
        "xtdc_ttf.tar.gz"
        "xtdc_skel.tar.gz"
        "xtdc"
    )

    PACOTES_REMOVER=(
	aisleriot apport apport-symptoms aspell aspell-en atmel-firmware atril
	atril-common avahi-utils b43-fwcutter bluetooth bluez bluez-firmware
	cheese cheese-common cups-browsed cups-pk-helper debian-faq deja-dup duplicity
	firefox firefox-esr
	gigolo gir1.2-cheese-3.0 gnome-characters gnome-font-viewer
	gnome-initial-setup gnome-logs gnome-mahjongg gnome-mines gnome-online-accounts
	gnome-software-plugin-snap gnome-sudoku gucharmap hunspell-en-us libcheese8
	libreoffice-calc libreoffice-gtk libreoffice-style-elementary libreoffice-writer mate-calc
	mate-calc-common mousepad openvpn parole pocketsphinx-en-us printer-driver-* remmina rhythmbox
	sane-airscan simple-scan snapd system-config-printer system-config-printer-common
	system-config-printer-udev thunderbird totem ubuntu-docs usb-creator-gtk wireless-regdb
	wireless-tools wpasupplicant xfburn xfce4-dict xfce4-power-manager xfce4-weather-plugin
:'
    firmware-ast firmware-atheros firmware-b43-installer
	firmware-b43legacy-installer firmware-bnx2 firmware-bnx2x firmware-brcm80211
	firmware-cavium firmware-cirrus firmware-intel-graphics firmware-intel-misc
	firmware-intel-sound firmware-ipw2x00 firmware-ivtv firmware-iwlwifi firmware-libertas
	firmware-marvell-prestera firmware-mediatek firmware-misc-nonfree firmware-myricom
	firmware-netronome firmware-netxen firmware-qlogic firmware-realtek firmware-siano firmware-sof-signed
	fonts-cantarell fonts-mathjax fonts-quicksand fonts-tlwg-garuda
	fonts-tlwg-garuda-ttf fonts-tlwg-kinnari fonts-tlwg-kinnari-ttf
	fonts-tlwg-laksaman fonts-tlwg-laksaman-ttf fonts-tlwg-loma fonts-tlwg-loma-ttf
	fonts-tlwg-mono fonts-tlwg-mono-ttf fonts-tlwg-norasi fonts-tlwg-norasi-ttf
	fonts-tlwg-purisa fonts-tlwg-purisa-ttf fonts-tlwg-sawasdee fonts-tlwg-sawasdee-ttf
	fonts-tlwg-typewriter fonts-tlwg-typewriter-ttf fonts-tlwg-typist fonts-tlwg-typist-ttf
	fonts-tlwg-typo fonts-tlwg-typo-ttf fonts-tlwg-umpush fonts-tlwg-umpush-ttf fonts-tlwg-waree fonts-tlwg-waree-ttf
'
    )
}
xtdc_vars


xtdc_loga(){
    local msg="${1:-}"
    local log_file="/xtdc/$(date +'%Y_%m_%d')_log.txt"
    echo "$msg" >> "$log_file"
}


xtdc_limpeza(){

    printf "${COLOR_HEADER}LIMPEZA DO SISTEMA${COLOR_RESET}\n\n"

    if ! command -v apt-get &>/dev/null || ! command -v dpkg &>/dev/null; then
        printf "${COLOR_ERROR}Erro: Sistema de pacotes não encontrado${COLOR_RESET}\n"
        return 1
    fi

    printf "Atualizando lista de pacotes... "
    if apt-get update -qq &>/dev/null; then
        printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"
    else
        printf "${COLOR_ERROR}FALHA${COLOR_RESET}\n"
        return 1
    fi

    printf "\n${COLOR_HEADER}REMOVENDO PACOTES DESNECESSÁRIOS:${COLOR_RESET}\n"

    for pkg in "${PACOTES_REMOVER[@]}"; do
        printf "  ${pkg%%\*}... "
        if dpkg -l | grep -q "^ii.*${pkg%%\*}"; then
            if apt-get purge -y "$pkg" &>/dev/null; then
                printf "${COLOR_SUCCESS}REMOVIDO${COLOR_RESET}\n"
            else
                printf "${COLOR_WARNING}️FALHOU${COLOR_RESET}\n"
            fi
        else
            printf "${COLOR_INFO}️NÃO INSTALADO${COLOR_RESET}\n"
        fi
    done

    if dpkg -l snapd &>/dev/null; then
        printf "\nRemovendo Snap completamente... "
        systemctl stop snapd.{socket,service} &>/dev/null
        if apt-get purge -y snapd gnome-software-plugin-snap &>/dev/null; then
            rm -rf /snap /var/snap /var/lib/snapd ~/snap &>/dev/null
            printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"
        else
            printf "${COLOR_ERROR}FALHA${COLOR_RESET}\n"
        fi
    fi

    printf "\n${COLOR_HEADER}LIMPANDO RESÍDUOS DO SISTEMA:${COLOR_RESET}\n"

    printf "Removendo pacotes órfãos... "
    if apt-get autoremove -y --purge &>/dev/null; then
        printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"
    else
        printf "${COLOR_ERROR}FALHA${COLOR_RESET}\n"
    fi

    printf "Limpando cache... "
    apt-get clean &>/dev/null
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* &>/dev/null
    printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"

    printf "\n${COLOR_SUCCESS}Limpeza concluída com sucesso${COLOR_RESET}\n"
    printf "${COLOR_WARNING}️ Recomenda-se reiniciar o sistema.${COLOR_RESET}\n"

    rm -rf /usr/share/fonts/truetype/tlwg
}


xtdc_pkg(){
    printf "${COLOR_HEADER}INSTALANDO PACOTES E APLICATIVOS${COLOR_RESET}\n\n"

    printf "Atualizando repositórios... "
    if apt-get update -qq; then
        printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"
    else
        printf "${COLOR_ERROR}FALHA${COLOR_RESET}\n"
        return 1
    fi

    printf "\nVERIFICANDO PACOTES DO REPOSITÓRIO\n"

    local -a installed_pkgs
    local -a to_install

    for pkg in "${PKGS[@]}"; do
        if dpkg -s "$pkg" >/dev/null 2>&1; then
            installed_pkgs+=("$pkg")
        else
            to_install+=("$pkg")
        fi
    done

    if [ ${#to_install[@]} -gt 0 ]; then
        printf "\nINSTALANDO %d PACOTES\n" "${#to_install[@]}"

        if apt-get install -y --no-install-recommends "${to_install[@]}" >/dev/null 2>&1; then
            printf "  ${COLOR_SUCCESS}Pacotes instalados com sucesso${COLOR_RESET}\n"
        else
            printf "  ${COLOR_ERROR}Erro na instalação de alguns pacotes${COLOR_RESET}\n"
        fi
    else
        printf "  ${COLOR_INFO}Todos os pacotes já estão instalados${COLOR_RESET}\n"
    fi

    printf "\nAPLICATIVOS EXTERNOS\n"

    printf "${COLOR_HEADER}INSTALANDO GOOGLE CHROME${COLOR_RESET}\n\n"

    printf "  Google Chrome... "
    if ! [ -x /usr/bin/google-chrome ] && ! [ -x /opt/google/chrome/google-chrome ]; then
        if curl -fsSL https://dl.google.com/linux/linux_signing_key.pub \
            | gpg --dearmor \
            | tee /usr/share/keyrings/google-chrome.gpg >/dev/null \
        && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
            | tee /etc/apt/sources.list.d/google-chrome.list >/dev/null \
        && apt update -qq >/dev/null \
        && apt install -y google-chrome-stable >/dev/null 2>&1; then
            printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"
        else
            printf "${COLOR_ERROR}FALHA${COLOR_RESET}\n"
        fi
    else
        printf "${COLOR_INFO}JÁ INSTALADO${COLOR_RESET}\n"
    fi

    printf "\nEXTENSÕES DO GOOGLE CHROME\n"

    mkdir -p -m 755 "$CHROME_EXT_DIR"

    for ext_id in "${!CHROME_EXT[@]}"; do
        printf "  ${CHROME_EXT[$ext_id]}... "

        if echo '{ "external_update_url": "https://clients2.google.com/service/update2/crx" }' \
            > "${CHROME_EXT_DIR}/${ext_id}.json"; then
            printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"
        else
            printf "${COLOR_ERROR}FALHA${COLOR_RESET}\n"
        fi
    done

    printf "\n${COLOR_SUCCESS}Instalação concluída com sucesso${COLOR_RESET}\n"

    printf "  Rclone... "
    if ! command -v rclone >/dev/null; then
        if curl -fsSL https://rclone.org/install.sh | bash >/dev/null 2>&1; then
            printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"
        else
            printf "${COLOR_ERROR}FALHA${COLOR_RESET}\n"
        fi
    else
        printf "${COLOR_INFO}JÁ INSTALADO${COLOR_RESET}\n"
    fi

    printf "  Brave Browser... "
    if ! command -v brave-browser >/dev/null &&
       ! [ -x /opt/brave.com/brave/brave ]; then
        if curl -fsSL https://dl.brave.com/install.sh | bash >/dev/null 2>&1; then
            printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"
        else
            printf "${COLOR_ERROR}FALHA${COLOR_RESET}\n"
        fi
    else
        printf "${COLOR_INFO}JÁ INSTALADO${COLOR_RESET}\n"
    fi

    printf "\nEXTENSÕES DO BRAVE\n"
    mkdir -p -m 755 "$BRAVE_EXT_DIR" 2>/dev/null

    for ext_id in "${!BRAVE_EXT[@]}"; do
        printf "  ${BRAVE_EXT[$ext_id]}... "
        if echo '{ "external_update_url": "https://clients2.google.com/service/update2/crx" }' \
            > "${BRAVE_EXT_DIR}/${ext_id}.json" 2>/dev/null; then
            printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"
        else
            printf "${COLOR_ERROR}FALHA${COLOR_RESET}\n"
        fi
    done

    printf "\n${COLOR_SUCCESS}Instalação concluída com sucesso${COLOR_RESET}\n"
}


xtdc_ptbr(){
#####################################################################
set -euo pipefail

LOCALE="pt_BR.UTF-8"
LANGUAGE_VALUE="pt_BR:pt"

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y locales ca-certificates

# 1) Garantir locale no /etc/locale.gen
LOCALE_GEN_LINE="${LOCALE} UTF-8"
if grep -qE '^[#]*[[:space:]]*'"$LOCALE_GEN_LINE"'\b' /etc/locale.gen; then
  sed -i -E 's/^[#][[:space:]]*('"$LOCALE_GEN_LINE"')/\1/' /etc/locale.gen
else
  echo "$LOCALE_GEN_LINE" >> /etc/locale.gen
fi

# 2) Gerar locale
locale-gen "$LOCALE"

# 3) Definir como padrão do sistema
cat > /etc/default/locale <<EOF
LANG=${LOCALE}
LANGUAGE=${LANGUAGE_VALUE}
LC_ALL=${LOCALE}
EOF

# Aplicar imediatamente
update-locale LANG="${LOCALE}" LANGUAGE="${LANGUAGE_VALUE}" LC_ALL="${LOCALE}" || true

# 4) Configurar /etc/skel para futuros usuários
install -d -m 0755 /etc/skel

# .profile (login shells)
cat > /etc/skel/.profile <<EOF
export LANG=${LOCALE}
export LANGUAGE=${LANGUAGE_VALUE}
export LC_ALL=${LOCALE}
EOF

# .bashrc (interactive shells)
cat > /etc/skel/.bashrc <<EOF
export LANG=${LOCALE}
export LANGUAGE=${LANGUAGE_VALUE}
export LC_ALL=${LOCALE}
EOF

# 5) Também vale setar no ambiente do root (já que você está como root)
cat > /root/.profile <<EOF
export LANG=${LOCALE}
export LANGUAGE=${LANGUAGE_VALUE}
export LC_ALL=${LOCALE}
EOF

cat > /root/.bashrc <<EOF
export LANG=${LOCALE}
export LANGUAGE=${LANGUAGE_VALUE}
export LC_ALL=${LOCALE}
EOF

echo "OK. Verificando:"
echo "Sistema:"
locale || true

echo
echo "Arquivos relevantes:"
echo "/etc/default/locale"
echo "/etc/skel/.profile"
echo "/etc/skel/.bashrc"
}


#####################################################################


xtdc_download(){
	    mkdir -p -m 755 "$DOWNLOAD_DIR" || {
        printf "${COLOR_ERROR}Falha ao criar diretório ${DOWNLOAD_DIR}${COLOR_RESET}\n"
        return 1
    }

    printf "${COLOR_HEADER}Iniciando downloads...${COLOR_RESET}\n"
    for file in "${FILE_LIST[@]}"; do
        printf "${COLOR_INFO}Baixando ${file}...${COLOR_RESET}\n"
        curl -sL "${GH_URL}/${file}" -o "${DOWNLOAD_DIR}/${file}" || {
            printf "${COLOR_ERROR}Falha no download de ${file}${COLOR_RESET}\n"
            continue
        }
        printf "${COLOR_SUCCESS}${file} baixado com sucesso${COLOR_RESET}\n"
    done

    chmod -R u+rwX,go+rX "$DOWNLOAD_DIR" > /dev/null 2>&1
    printf "${COLOR_SUCCESS}Downloads concluídos${COLOR_RESET}\n"
}


xtdc_appimage(){
    mkdir -p -m 755 "$INSTALL_DIR" || {
        echo "Erro ao criar diretório $INSTALL_DIR"
        return 1
    }
    echo "Baixando LibreOffice AppImage..."
    wget -q --show-progress -O "$INSTALL_DIR/$LO_FILENAME" "$LO_URL" || {
        echo "Erro ao baixar o arquivo"
        return 1
    }

    echo "Baixando Pinta AppImage..."
    wget -q --show-progress -O "$INSTALL_DIR/$PINTA_FILENAME" "$PINTA_URL" || {
        echo "Erro ao baixar o arquivo"
        return 1
    }

        echo "Baixando SpeedCrunch AppImage..."
    wget -q --show-progress -O "$INSTALL_DIR/$SC_FILENAME" "$SC_URL" || {
        echo "Erro ao baixar o arquivo"
        return 1
    }
    
    chmod +x "$INSTALL_DIR/$LO_FILENAME" || {
        echo "Erro ao tornar o AppImage executável"
        return 1
    }

    chmod +x "$INSTALL_DIR/$PINTA_FILENAME" || {
        echo "Erro ao tornar o AppImage executável"
        return 1
    }

    chmod +x "$INSTALL_DIR/$SC_FILENAME" || {
        echo "Erro ao tornar o AppImage executável"
        return 1
    }



    echo "Criando arquivos .desktop..."
    cat > "$LO_DESKTOP_FILE" <<'EOL'
[Desktop Entry]
Type=Application
Name=LibreOffice
Comment=Suíte Office Completa
Exec=/xtdc/appimages/LibreOffice-still.standard-x86_64.AppImage
Icon=libreoffice
Terminal=false
Categories=Office;
MimeType=application/vnd.openxmlformats-officedocument.wordprocessingml.document;application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;application/vnd.openxmlformats-officedocument.presentationml.presentation;application/msword;application/vnd.ms-excel;application/vnd.ms-powerpoint;application/vnd.oasis.opendocument.text;application/vnd.oasis.opendocument.spreadsheet;application/vnd.oasis.opendocument.presentation;
StartupNotify=true
EOL

    cat > "$PINTA_DESKTOP_FILE" <<'EOL'
[Desktop Entry]
Name=Pinta
Comment=Editor de bitmap (MS Paint)
TryExec=pinta
Exec=/xtdc/appimages/Pinta.AppImage
Icon=pinta
StartupNotify=false
StartupWMClass=Pinta
Terminal=false
Type=Application
Categories=Graphics;
Keywords=draw;drawing;paint;painting;graphics;raster;2d;
MimeType=image/bmp;image/gif;image/jpeg;image/jpg;image/pjpeg;image/png;image/svg+xml;image/tiff;image/x-bmp;image/x-gray;image/x-icb;image/x-ico;image/x-png;image/x-portable-anymap;image/x-portable-bitmap;image/x-portable-graymap;image/x-portable-pixmap;image/x-xbitmap;image/x-xpixmap;image/x-pcx;image/x-targa;image/x-tga;image/openraster;
EOL

    cat > "$SC_DESKTOP_FILE" <<'EOL'
[Desktop Entry]
Name=Calculadora
Comment=Calculadora
Exec=/bin/xtdc xtdc_calculadoranotopo
Icon=speedcrunch
Terminal=false
Type=Application
Categories=Utility;
EOL

    update-desktop-database || {
        echo "Erro ao atualizar o banco de dados de desktop"
        return 1
    }

    echo "Configurando como aplicativo padrão..."
    local MIME_TYPES=(
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        "application/vnd.openxmlformats-officedocument.presentationml.presentation"
        "application/msword"
        "application/vnd.ms-excel"
        "application/vnd.ms-powerpoint"
    )

    for mime in "${MIME_TYPES[@]}"; do
        xdg-mime default libreoffice-appimage.desktop "$mime" || {
            echo "Erro ao configurar padrão para $mime"
        }
    done

    echo "Instalação concluída com sucesso!"
    echo "LibreOffice AppImage instalado em: $INSTALL_DIR/$LO_FILENAME"
    echo "Pinta AppImage instalado em: $INSTALL_DIR/$PINTA_FILENAME"
}


xtdc_tema(){
    if [ -d "/usr/share/lightdm" ]; then
        mkdir -p -m 755 "${LIGHTDM_CONF_DIR}" && chmod 755 "${LIGHTDM_CONF_DIR}" && {
            cat <<'EOF' | tee "${LIGHTDM_CONF_DIR}/01_ubuntu.conf" >/dev/null
[greeter]
background=#000000
theme-name=xtdc_theme
icon-theme-name=xtdc_svg
font-name=Ubuntu 13
indicators=~clock;
clock-format=%d %b, %H:%M%S
EOF

            cat <<'EOF' | tee "${LIGHTDM_CONF_DIR}/30_xubuntu.conf" >/dev/null
[greeter]
background=#000000
theme-name=xtdc_theme
icon-theme-name=xtdc_svg
font-name=Noto Sans 11
keyboard=onboard
screensaver-timeout=60
EOF

            chmod 644 "${LIGHTDM_CONF_DIR}"/*.conf 2>/dev/null
            printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"
        } || {
            printf "${COLOR_ERROR}FALHA${COLOR_RESET}\n"
            return 1
        }
    fi

    printf "${COLOR_HEADER}Iniciando instalação...${COLOR_RESET}\n"

    for file in "${REQUIRED_FILES[@]}"; do
        if [ ! -f "${DOWNLOAD_DIR}/${file}" ]; then
            printf "${COLOR_ERROR}Arquivo ${file} não encontrado em ${DOWNLOAD_DIR}${COLOR_RESET}\n"
            printf "${COLOR_INFO}Execute xtdc_download primeiro para baixar os arquivos.${COLOR_RESET}\n"
            return 1
        fi
    done

    printf "${COLOR_INFO}Instalando skel...${COLOR_RESET}\n"
    tar -xzf "${DOWNLOAD_DIR}/xtdc_skel.tar.gz" -C /etc/ || {
        printf "${COLOR_ERROR}Falha ao descompactar skel${COLOR_RESET}\n"
        return 1
    }

    printf "${COLOR_INFO}Instalando ícones...${COLOR_RESET}\n"
    tar -xzf "${DOWNLOAD_DIR}/xtdc_icons.tar.gz" -C /usr/share/icons/ || {
        printf "${COLOR_ERROR}Falha ao descompactar ícones${COLOR_RESET}\n"
        return 1
    }

    printf "${COLOR_INFO}Instalando temas...${COLOR_RESET}\n"
    tar -xzf "${DOWNLOAD_DIR}/xtdc_theme.tar.gz" -C /usr/share/themes/ || {
        printf "${COLOR_ERROR}Falha ao descompactar temas${COLOR_RESET}\n"
        return 1
    }

    printf "${COLOR_INFO}Instalando fontes...${COLOR_RESET}\n"
    tar -xzf "${DOWNLOAD_DIR}/xtdc_ttf.tar.gz" -C /usr/share/fonts/truetype/ || {
        printf "${COLOR_ERROR}Falha ao descompactar fontes${COLOR_RESET}\n"
        return 1
    }

    printf "${COLOR_INFO}Instalando executável...${COLOR_RESET}\n"
    mv "${DOWNLOAD_DIR}/xtdc" /bin/ || {
        printf "${COLOR_ERROR}Falha ao mover o executável${COLOR_RESET}\n"
        return 1
    }

    chmod 755 /bin/xtdc || {
        printf "${COLOR_ERROR}Falha ao definir permissões do executável${COLOR_RESET}\n"
        return 1
    }

    if command -v fc-cache >/dev/null 2>&1; then
        printf "${COLOR_INFO}Atualizando cache de fontes...${COLOR_RESET}\n"
        fc-cache -f > /dev/null 2>&1
    fi

    printf "${COLOR_SUCCESS}Instalação concluída com sucesso${COLOR_RESET}\n"
    printf "${COLOR_INFO}Os seguintes itens foram instalados:\n"
    printf "  - Ícones: /usr/share/icons/xtdc_icons e /usr/share/icons/xtdc_svg\n"
    printf "  - Temas: /usr/share/themes/xtdc_theme e /usr/share/themes/xtdc_dark\n"
    printf "  - Fontes: /usr/share/fonts/truetype/xtdc_ttf\n"
    printf "  - Executável: /bin/xtdc (com permissões 755)${COLOR_RESET}\n"
}


xtdc_roda(){
# Criação do arquivo de log
NOW=$(date +'%Y_%m_%d_%H_%M_%S')
LOG_FILE="/xtdc/xtdc_log_${NOW}.txt"

{
    echo "$NOW"
    echo "=== XTDC Setup Log ==="
} > "$LOG_FILE"

chmod 644 "$LOG_FILE"

printf "${COLOR_HEADER}Iniciando Automação XTDC...${COLOR_RESET}\n"
apt update 
apt install -y curl > /dev/null 2>&1
xtdc_vars
xtdc_pkg
xtdc_download
xtdc_appimage
xtdc_tema
xtdc_limpeza
printf "${COLOR_SUCCESS}Todo o processo foi concluído. Log salvo em: $LOG_FILE${COLOR_RESET}\n"
printf "${COLOR_WARNING}Recomenda-se reiniciar o sistema.${COLOR_RESET}\n"
}


xtdc_lista(){
rclone-browser transmission brave
smplayer simplescreenrecorder kodi
eog shotwell pinta
baobab clipit file-roller catfish menulibre
bleachbit evince geany gnome-disk-utility 
gnome-system-monitor gnome-system-tools gparted
p7zip-full rar unrar thunar-archive-plugin
synaptic tree xclip wmctrl


}


xtdc_instala(){
	
PKGS=$(cat <<'EOF'
    xablau
EOF
)

# 1) lista dos programas já instalados (apenas nomes limpos), feita uma vez
INSTALADOS="$(dpkg-query -W -f='${binary:Package}\n' 2>/dev/null)"

tem_no_passado(){
  # $1 = pacote
  printf "%s\n" "$INSTALADOS" | grep -Fxq -- "$1"
}

# 2) lê PKGS item a item (aceita várias linhas e espaços)
echo "$PKGS" | while IFS= read -r line; do
  # ignora comentários e linhas vazias
  case "$line" in
    \#*) continue ;;
    "") continue ;;
  esac

  # 3) cada linha pode ter vários pacotes separados por espaço
  for pkg in $line; do
    [ -z "$pkg" ] && continue

    if tem_no_passado "$pkg"; then
      echo "$pkg JÁ ESTAVA INSTALADO"
    else
      # instala se não estiver (se não quiser instalar, troque por só echo)
      if apt-get install -y --no-install-recommends "$pkg" >/dev/null 2>&1; then
        echo "$pkg FOI INSTALADO COM SUCESSO"
      else
        echo "$pkg FALHA NA INSTALAÇÃO"
      fi
    fi
  done
done
}


novo(){


COLOR_SUCCESS="\e[32m"
COLOR_ERROR="\e[31m"
COLOR_INFO="\e[34m"
COLOR_RESET="\e[0m"

xtdc_loga(){
  LOG_FILE="${HOME:-/tmp}/$(date +'%Y_%m_%d')_log.txt"
  echo "$1" >> "$LOG_FILE"
}

installed_pkgs=()
to_install=()

PKGS=(
  smplayer simplescreenrecorder kodi
  eog shotwell
  baobab catfish menulibre
  evince geany gnome-disk-utility
  gnome-system-monitor gnome-system-tools gparted
  p7zip-full rar unrar synaptic wmctrl
)

for pkg in "${PKGS[@]}"; do
  if dpkg -s "$pkg" >/dev/null 2>&1; then
    installed_pkgs+=("$pkg")
    xtdc_loga "$pkg já instalado"
  else
    to_install+=("$pkg")
    xtdc_loga "$pkg será instalado"
  fi
done

if [ ${#to_install[@]} -gt 0 ]; then
  printf "\nINSTALANDO %d PACOTES\n" "${#to_install[@]}"

  # Atualiza 1x antes de instalar
  apt-get update >/dev/null 2>&1

  if apt-get install -y --no-install-recommends "${to_install[@]}" >/dev/null 2>&1; then
    printf "  ${COLOR_SUCCESS}Pacotes instalados com sucesso${COLOR_RESET}\n"
    xtdc_loga "Instalação concluída: ${to_install[*]}"
  else
    printf "  ${COLOR_ERROR}Erro na instalação de alguns pacotes${COLOR_RESET}\n"
    xtdc_loga "Falha na instalação: ${to_install[*]}"
  fi
else
  printf "  ${COLOR_INFO}Todos os pacotes já estão instalados${COLOR_RESET}\n"
  xtdc_loga "Nenhum pacote a instalar (todos já instalados)."
fi



}


#sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list
#apt update
#apt install rar unrar
