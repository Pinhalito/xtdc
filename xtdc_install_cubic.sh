#!/bin/bash
#
#######################
#    ^...^  `^...^´   #
#   / o,o \ / O,O \   #
#   |):::(| |):::(|   #
# ====" "=====" "==== #
#         TdC         #
#      1998-2025      #
#######################
#
# Toca das Corujas
# Códigos Binários,
# Funções de Onda e
# Teoria do Orbital Molecular Inc.
# Unidade Barão Geraldo CX
#
# 2025_07_16_20_53_23
#
# =================================================⚡
# CONFIGURAÇÃO DE CORES
# =================================================⚡
COLOR_HEADER="\e[104m"
COLOR_SUCCESS="\e[1;32m"
COLOR_WARNING="\e[0;35m"
COLOR_ERROR="\e[1;31m"
COLOR_INFO="\e[1;36m"
COLOR_RESET="\033[0m"

# =================================================⚡
xtdc_ppa() {
    local PPAS=(
        afelinczak/ppa
        cubic-wizard/release
        geany-dev/ppa
        inkscape.dev/stable
        maarten-baert/simplescreenrecorder
        otto-kesselgulasch/gimp
        team-xbmc/ppa
        kisak/kisak-mesa
    )
    echo "▶ Instalando PPAs..."
    local needs_update=0
    for ppa in "${PPAS[@]}"; do
        echo -n "• $ppa... "
        if ! grep -rq "$ppa" /etc/apt/sources.list /etc/apt/sources.list.d/; then
            if add-apt-repository -y "ppa:$ppa" >/dev/null 2>&1; then
                echo "OK"
                needs_update=1
            else
                echo "FALHOU"
            fi
        else
            echo "JÁ INSTALADO"
        fi
    done
    [ "$needs_update" -eq 1 ] && apt-get update -qq
    echo "✔ Concluído!"
}

# =================================================⚡
xtdc_pkg() {
    declare -a PKGS=(
        baobab
        bleachbit
        catfish
        clipit
        curl
        curl
        eog
        evince
        file-roller
        geany
        gnome-disk-utility
        gnome-system-monitor
        gnome-system-tools
        gparted
        menulibre
        p7zip-full
        rar
        shotwell
        simplescreenrecorder
        smplayer
        speedcrunch
        synaptic
        thunar-archive-plugin
        transmission
        tree
        unrar
        xclip
        xfpanel-switch
        zenity
        language-pack-gnome-pt
        language-pack-gnome-pt-base
        language-pack-pt 
        language-pack-pt-base
    )
    printf "${COLOR_HEADER}⚡ INSTALANDO PACOTES E APLICATIVOS ⚡${COLOR_RESET}\n\n"
    printf "➔ Atualizando repositórios... "
    if apt-get update -qq; then
        printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"
    else
        printf "${COLOR_ERROR}FALHA${COLOR_RESET}\n"
        return 1
    fi    
    printf "\n➔ VERIFICANDO PACOTES DO REPOSITÓRIO\n"
    declare -a installed_pkgs
    declare -a to_install
    for pkg in "${PKGS[@]}"; do
        if dpkg -l | grep -q "^ii  $pkg "; then
            installed_pkgs+=("$pkg")
        else
            to_install+=("$pkg")
        fi
    done
    if [ ${#to_install[@]} -gt 0 ]; then
        printf "\n➔ INSTALANDO %d PACOTES\n" "${#to_install[@]}"
        if apt-get install -y --no-install-recommends "${to_install[@]}" >/dev/null; then
            printf "  ✔ ${COLOR_SUCCESS}Pacotes instalados com sucesso${COLOR_RESET}\n"
        else
            printf "  ✖ ${COLOR_ERROR}Erro na instalação de alguns pacotes${COLOR_RESET}\n"
        fi
    else
        printf "  ✔ ${COLOR_INFO}Todos os pacotes já estão instalados${COLOR_RESET}\n"
    fi
    printf "\n➔ APLICATIVOS EXTERNOS\n"
    
    printf "  ➔ Rclone... "
    if ! command -v rclone >/dev/null; then
        if curl -fsSL https://rclone.org/install.sh | bash >/dev/null; then
            printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"
        else
            printf "${COLOR_ERROR}FALHA${COLOR_RESET}\n"
        fi
    else
        printf "${COLOR_INFO}JÁ INSTALADO${COLOR_RESET}\n"
    fi

    printf "  ➔ Brave Browser... "
    if ! [ -f /usr/bin/brave-browser ] && ! [ -f /opt/brave.com/brave/brave ]; then
        if curl -fsSL https://dl.brave.com/install.sh | bash >/dev/null; then
            printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"
        else
            printf "${COLOR_ERROR}FALHA${COLOR_RESET}\n"
        fi
    else
        printf "${COLOR_INFO}JÁ INSTALADO${COLOR_RESET}\n"
    fi
    
    local BRAVE_EXT_DIR="/opt/brave.com/brave/extensions"
    declare -Ag BRAVE_EXT=(
        ["ponfpcnoihfmfllpaingbgckeeldkhle"]="Enhancer for YouTube™"
        ["mnjggcdmjocbbbhaepdhchncahnbgone"]="SponsorBlock para YouTube"
    )
    printf "\n➔ EXTENSÕES DO BRAVE\n"
    mkdir -p "$BRAVE_EXT_DIR" 2>/dev/null
    
    for ext_id in "${!BRAVE_EXT[@]}"; do
        printf "  ➔ ${BRAVE_EXT[$ext_id]}... "
        if echo '{ "external_update_url": "https://clients2.google.com/service/update2/crx" }' \
            > "${BRAVE_EXT_DIR}/${ext_id}.json" 2>/dev/null; then
            printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"
        else
            printf "${COLOR_ERROR}FALHA${COLOR_RESET}\n"
        fi
    done
    
    printf "\n${COLOR_SUCCESS}✔ Instalação concluída com sucesso${COLOR_RESET}\n"
}

# =================================================⚡
xtdc_limpeza() {
    declare -a PACOTES_REMOVER=(
        snapd
        gnome-software-plugin-snap
        libreoffice-*
        gnome-mahjongg
        gnome-sudoku
        gnome-mines
        aisleriot
        bluetooth
        bluez*
        cups
        cups-browsed
        printer-driver-*
        zeitgeist*
        apport
        apport-symptoms
        thunderbird
        cheese
        deja-dup
        duplicity
        gnome-characters
        gnome-font-viewer
        gnome-initial-setup
        gnome-logs
        gnome-online-accounts
        gnome-software-plugin-snap
        openvpn*
        remmina
        rhythmbox
        totem
        shotwell
        ubuntu-docs
        usb-creator-gtk
        yelp
        yelp-xsl
    )
    printf "${COLOR_HEADER}⚡ LIMPEZA DO SISTEMA ⚡${COLOR_RESET}\n\n"
    printf "➔ Atualizando lista de pacotes... "
    if apt-get update -qq &>/dev/null; then
        printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"
    else
        printf "${COLOR_ERROR}FALHA${COLOR_RESET}\n"
        return 1
    fi
    printf "\n${COLOR_HEADER}REMOVENDO PACOTES DESNECESSÁRIOS:${COLOR_RESET}\n"
    for pkg in "${PACOTES_REMOVER[@]}"; do
        printf "  ➔ ${pkg%%\*}... "
        if dpkg -l | grep -q "^ii.*${pkg%%\*}"; then
            if apt-get purge -y "$pkg" &>/dev/null; then
                printf "${COLOR_SUCCESS}REMOVIDO${COLOR_RESET}\n"
            else
                printf "${COLOR_WARNING}FALHOU${COLOR_RESET}\n"
            fi
        else
            printf "${COLOR_INFO}NÃO INSTALADO${COLOR_RESET}\n"
        fi
    done
    if dpkg -l snapd &>/dev/null; then
        printf "\n➔ Removendo Snap completamente... "
        systemctl stop snapd.{socket,service} &>/dev/null
        if apt-get purge -y snapd gnome-software-plugin-snap &>/dev/null; then
            rm -rf /snap /var/snap /var/lib/snapd ~/snap &>/dev/null
            printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"
        else
            printf "${COLOR_ERROR}FALHA${COLOR_RESET}\n"
        fi
    fi
    printf "\n${COLOR_HEADER}LIMPANDO RESÍDUOS DO SISTEMA:${COLOR_RESET}\n"
    printf "➔ Removendo pacotes órfãos... "
    if apt-get autoremove -y --purge &>/dev/null; then
        printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"
    else
        printf "${COLOR_ERROR}FALHA${COLOR_RESET}\n"
    fi
    printf "➔ Limpando cache... "
    apt-get clean &>/dev/null
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* &>/dev/null
    printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"
    printf "\n${COLOR_SUCCESS}✔ Limpeza concluída com sucesso${COLOR_RESET}\n"
    printf "${COLOR_WARNING}⚠ Recomenda-se reiniciar o sistema.${COLOR_RESET}\n"
}

# =================================================⚡
xtdc_tema() {
    local LIGHTDM_CONF_DIR="/usr/share/lightdm/lightdm-gtk-greeter.conf.d"
    printf "\n${COLOR_HEADER}⚡ CONFIGURANDO TEMA ⚡${COLOR_RESET}\n"
    if [ -d "/usr/share/lightdm" ]; then
        printf "  ➔ Configurando LightDM... "
        mkdir -p "${LIGHTDM_CONF_DIR}" && chmod 755 "${LIGHTDM_CONF_DIR}" && {
            # Configuração para Ubuntu
            cat <<EOF | tee "${LIGHTDM_CONF_DIR}/01_ubuntu.conf" >/dev/null
[greeter]
background=#000000
theme-name=xtdc_theme
icon-theme-name=xtdc_icons
font-name=Ubuntu 13
indicators=~host;~spacer;~session;~language;~a11y;~clock;~power;
clock-format=%d %b, %H:%M
EOF
            cat <<EOF | tee "${LIGHTDM_CONF_DIR}/30_xubuntu.conf" >/dev/null
[greeter]
background=#000000
theme-name=xtdc_theme
icon-theme-name=xtdc_icons
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
    else
        printf "  ✖ ${COLOR_WARNING}LightDM não encontrado${COLOR_RESET}\n"
    fi
    printf "  ➔ Atualizando cache de fontes... "
    fc-cache -f -v >/dev/null 2>&1 && \
    printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n" || \
    printf "${COLOR_WARNING}FALHA${COLOR_RESET}\n"
    printf "  ➔ Removendo documentação desnecessária... "
    if dpkg -l yelp >/dev/null 2>&1; then
        apt purge -y yelp yelp-xsl >/dev/null 2>&1 && \
        printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n" || \
        printf "${COLOR_WARNING}FALHA${COLOR_RESET}\n"
    else
        printf "${COLOR_INFO}JÁ REMOVIDO${COLOR_RESET}\n"
    fi
    printf "  ➔ Atualizando banco de dados de aplicativos... "
    update-desktop-database /etc/skel/.local/share/applications/ >/dev/null 2>&1 && \
    printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n" || \
    printf "${COLOR_WARNING}FALHA${COLOR_RESET}\n"
    printf "\n${COLOR_SUCCESS}✔ Configuração de tema concluída${COLOR_RESET}\n"
}

# =================================================⚡
xtdc_install_libreoffice_appimage() {
    local LO_URL="https://appimages.libreitalia.org/LibreOffice-fresh.standard-x86_64.AppImage"
    local LO_FILENAME="LibreOffice-fresh.standard-x86_64.AppImage"
    local INSTALL_DIR="/xtdc/AppImages"
    local DESKTOP_FILE="$HOME/.local/share/applications/libreoffice-appimage.desktop"
    local ICON_URL="https://upload.wikimedia.org/wikipedia/commons/thumb/5/5a/LibreOffice_Main_Logo.png/240px-LibreOffice_Main_Logo.png"
    local ICON_PATH="/usr/share/icons/xtdc_icons/apps/libreoffice.png"
    local MIME_TYPES=(
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        "application/vnd.openxmlformats-officedocument.presentationml.presentation"
        "application/msword"
        "application/vnd.ms-excel"
        "application/vnd.ms-powerpoint"
        "application/vnd.oasis.opendocument.text"
        "application/vnd.oasis.opendocument.spreadsheet"
        "application/vnd.oasis.opendocument.presentation"
    )
    mkdir -p "$INSTALL_DIR" || {
        echo "Erro ao criar diretório $INSTALL_DIR" >&2
        return 1
    }
    echo "Baixando LibreOffice AppImage..."
    wget -q --show-progress -O "$INSTALL_DIR/$LO_FILENAME" "$LO_URL" || {
        echo "Erro ao baixar o arquivo" >&2
        return 1
    }
    chmod +x "$INSTALL_DIR/$LO_FILENAME" || {
        echo "Erro ao tornar o AppImage executável" >&2
        return 1
    }
    mkdir -p "$(dirname "$ICON_PATH")"
    if [[ ! -f "$ICON_PATH" ]]; then
        echo "Baixando ícone do LibreOffice..."
        wget -q -O "$ICON_PATH" "$ICON_URL" || {
            echo "Erro ao baixar o ícone" >&2
        }
    fi
    echo "Criando arquivo .desktop..."
    cat > "$DESKTOP_FILE" <<EOL
[Desktop Entry]
Type=Application
Name=LibreOffice
Comment=Suíte Office Completa
Exec=$INSTALL_DIR/$LO_FILENAME
Icon=$ICON_PATH
Terminal=false
Categories=Office;
MimeType=$(IFS=';'; echo "${MIME_TYPES[*]}")
StartupNotify=true
EOL
    update-desktop-database || {
        echo "Erro ao atualizar o banco de dados de desktop" >&2
        return 1
    }
    echo "Configurando como aplicativo padrão..."
    for mime in "${MIME_TYPES[@]}"; do
        xdg-mime default libreoffice-appimage.desktop "$mime" || {
            echo "Erro ao configurar padrão para $mime" >&2
        }
    done
    echo "Instalação concluída com sucesso!"
    echo "LibreOffice AppImage instalado em: $INSTALL_DIR/$LO_FILENAME"
}

# =================================================⚡
xtdc_install_gimp_appimage() {
    local GIMP_URL="https://edgeuno-bog2.mm.fcix.net/gimp/gimp/v3.0/linux/GIMP-3.0.4-x86_64.AppImage"
    local GIMP_FILENAME="GIMP-3.0.4-x86_64.AppImage"
    local INSTALL_DIR="/xtdc25/AppImages"
    local DESKTOP_FILE="$HOME/.local/share/applications/gimp-appimage.desktop"
    local ICON_URL="https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/The_GIMP_icon_-_gnome.svg/240px-The_GIMP_icon_-_gnome.svg.png"
    local ICON_PATH="/usr/share/icons/xtdc_icons/apps/gimp.png"
    local MIME_TYPES=(
        "image/bmp"
        "image/gif"
        "image/jpeg"
        "image/jpg"
        "image/png"
        "image/svg+xml"
        "image/tiff"
        "image/webp"
        "image/x-eps"
        "image/x-psd"
        "image/x-tga"
        "application/postscript"
    )
    mkdir -p "$INSTALL_DIR" || {
        echo "Erro ao criar diretório $INSTALL_DIR" >&2
        return 1
    }
    echo "Baixando GIMP AppImage..."
    wget -q --show-progress -O "$INSTALL_DIR/$GIMP_FILENAME" "$GIMP_URL" || {
        echo "Erro ao baixar o arquivo" >&2
        return 1
    }
    chmod +x "$INSTALL_DIR/$GIMP_FILENAME" || {
        echo "Erro ao tornar o AppImage executável" >&2
        return 1
    }
    mkdir -p "$(dirname "$ICON_PATH")"
    if [[ ! -f "$ICON_PATH" ]]; then
        echo "Baixando ícone do GIMP..."
        wget -q -O "$ICON_PATH" "$ICON_URL" || {
            echo "Erro ao baixar o ícone" >&2
        }
    fi
    echo "Criando arquivo .desktop..."
    cat > "$DESKTOP_FILE" <<EOL
[Desktop Entry]
Type=Application
Name=GIMP
Comment=Editor de imagens avançado
Exec=$INSTALL_DIR/$GIMP_FILENAME
Icon=$ICON_PATH
Terminal=false
Categories=Graphics;
MimeType=$(IFS=';'; echo "${MIME_TYPES[*]}")
StartupNotify=true
Keywords=imagem;editor;GIMP;graphic;design;illustration;painting;
EOL
    update-desktop-database || {
        echo "Erro ao atualizar o banco de dados de desktop" >&2
        return 1
    }
    echo "Configurando como aplicativo padrão..."
    for mime in "${MIME_TYPES[@]}"; do
        xdg-mime default gimp-appimage.desktop "$mime" || {
            echo "Erro ao configurar padrão para $mime" >&2
        }
    done
    echo "Instalação concluída com sucesso!"
    echo "GIMP AppImage instalado em: $INSTALL_DIR/$GIMP_FILENAME"
    echo "Execute com: $INSTALL_DIR/$GIMP_FILENAME"
}

# /etc/apt/apt.conf.d/20apt-esm-hook.conf
# sudo dpkg-divert --divert /etc/apt/apt.conf.d/20apt-esm-hook.conf.bak --rename --local /etc/apt/apt.conf.d/20apt-esm-hook.conf


# FIM
