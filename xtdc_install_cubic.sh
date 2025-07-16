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
# 2025_07_15_21_54_32
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

    if [ "$(id -u)" -ne 0 ]; then
        printf "${COLOR_WARNING}Este script requer privilégios de root.${COLOR_RESET}\n"
        printf "${COLOR_WARNING}Por favor insira a senha quando solicitado...${COLOR_RESET}\n"
        sudo "$0" "$@"
        exit $?
    fi
    printf "${COLOR_SUCCESS}✓ Privilégios de root confirmados.${COLOR_RESET}\n"

# =================================================⚡
xtdc_ppa() {
    declare -Ag PPAS=(
        ["afelinczak/ppa"]="Cliptit - Clipboard manager"
        ["cubic-wizard/release"]="Cubic Customizer"
        ["geany-dev/ppa"]="Geany IDE (versão mais recente)"
        ["inkscape.dev/stable"]="Inkscape (última versão estável)"
        ["maarten-baert/simplescreenrecorder"]="SimpleScreenRecorder"
        ["otto-kesselgulasch/gimp"]="GIMP (versões mais recentes)"
        ["team-xbmc/ppa"]="Kodi Media Center"
        ["kisak/kisak-mesa"]="Drivers AMD Ryzen 5 2400G with Radeon Vega Graphics"
    )

    printf "${COLOR_HEADER}⚡ INSTALANDO REPOSITÓRIOS PPA ⚡${COLOR_RESET}\n\n"
    local NEEDS_UPDATE=0

    for ppa in "${!PPAS[@]}"; do
        printf "➔ ${PPAS[$ppa]}... "
        if ! grep -rq "ppa.launchpad.net/$ppa" /etc/apt/sources.list /etc/apt/sources.list.d/; then
            if add-apt-repository -y "ppa:$ppa" >/dev/null 2>&1; then
                printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"
                NEEDS_UPDATE=1
            else
                printf "${COLOR_ERROR}FALHOU${COLOR_RESET}\n"
            fi
        else
            printf "${COLOR_INFO}JÁ INSTALADO${COLOR_RESET}\n"
        fi
    done

    if [ "$NEEDS_UPDATE" -eq 1 ]; then
        printf "\n${COLOR_INFO}🔄 Atualizando lista de pacotes...${COLOR_RESET}\n"
        apt-get update -qq
    fi
    printf "\n${COLOR_SUCCESS}✔ PPAs configurados com sucesso${COLOR_RESET}\n"
}

# =================================================⚡
xtdc_pkg() {
    local BRAVE_EXT_DIR="/opt/brave.com/brave/extensions"
    
    # Lista consolidada de pacotes para instalação
    declare -a PKGS=(
        # Utilitários de sistema
        rclone-browser transmission smplayer simplescreenrecorder
        eog shotwell baobab clipit file-roller catfish menulibre
        curl bleachbit evince geany gnome-disk-utility
        gnome-system-monitor gnome-system-tools gparted
        p7zip-full rar unrar thunar-archive-plugin
        speedcrunch synaptic tree xfpanel-switch zenity xclip
        
        # Pacotes de idioma
        language-pack-gnome-pt language-pack-gnome-pt-base 
        language-pack-pt language-pack-pt-base
        
        # Rede e compartilhamento
        fusesmb gvfs-backends gvfs-fuse samba-libs
    )

    # Extensões do Brave Browser
    declare -Ag BRAVE_EXT=(
        ["ponfpcnoihfmfllpaingbgckeeldkhle"]="Enhancer for YouTube™"
        ["mnjggcdmjocbbbhaepdhchncahnbgone"]="SponsorBlock para YouTube"
    )

    printf "${COLOR_HEADER}⚡ INSTALANDO PACOTES E APLICATIVOS ⚡${COLOR_RESET}\n\n"
    
    # Atualizar repositórios
    printf "➔ Atualizando repositórios... "
    if apt-get update -qq; then
        printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"
    else
        printf "${COLOR_ERROR}FALHA${COLOR_RESET}\n"
        return 1
    fi
    
    # Verificar e instalar pacotes
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
    
    # Instalar aplicativos externos
    printf "\n➔ APLICATIVOS EXTERNOS\n"
    
    # Rclone
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
    
    # Brave Browser
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
    
    # Extensões do Brave
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
    # Lista consolidada de pacotes para remoção
    declare -a PACOTES_REMOVER=(
        # Snap e relacionados
        snapd gnome-software-plugin-snap
        
        # Pacotes do LibreOffice
        libreoffice-*
        
        # Jogos
        gnome-mahjongg gnome-sudoku gnome-mines aisleriot
        
        # Bluetooth e impressão
        bluetooth bluez* cups-browsed printer-driver-*
        
        # Serviços desnecessários
        zeitgeist* apport apport-symptoms thunderbird
        
        # Aplicativos não utilizados
        cheese deja-dup duplicity gnome-characters gnome-font-viewer
        gnome-initial-setup gnome-logs gnome-online-accounts
        gnome-software-plugin-snap openvpn* remmina rhythmbox
        totem shotwell ubuntu-docs usb-creator-gtk yelp yelp-xsl
        
        # Pacotes de idioma não utilizados
        language-pack-de language-pack-de-base language-pack-en
        language-pack-en-base language-pack-es language-pack-es-base
        language-pack-fr language-pack-fr-base language-pack-gnome-de
        language-pack-gnome-de-base language-pack-gnome-en
        language-pack-gnome-en-base language-pack-gnome-es
        language-pack-gnome-es-base language-pack-gnome-fr
        language-pack-gnome-fr-base language-pack-gnome-it
        language-pack-gnome-it-base language-pack-gnome-ru-base
        language-pack-gnome-zh-hans language-pack-gnome-zh-hans-base
        language-pack-gnome-ru language-pack-it language-pack-it-base
        language-pack-ru language-pack-ru-base language-pack-zh-hans
        language-pack-zh-hans-base
    )

    printf "${COLOR_HEADER}⚡ LIMPEZA DO SISTEMA ⚡${COLOR_RESET}\n\n"
    
    # Verificar se o sistema de pacotes está disponível
    if ! command -v apt-get &>/dev/null || ! command -v dpkg &>/dev/null; then
        printf "${COLOR_ERROR}✖ Erro: Sistema de pacotes não encontrado${COLOR_RESET}\n"
        return 1
    fi

    # Atualizar lista de pacotes
    printf "➔ Atualizando lista de pacotes... "
    if apt-get update -qq &>/dev/null; then
        printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"
    else
        printf "${COLOR_ERROR}FALHA${COLOR_RESET}\n"
        return 1
    fi

    # Remover pacotes desnecessários
    printf "\n${COLOR_HEADER}REMOVENDO PACOTES DESNECESSÁRIOS:${COLOR_RESET}\n"
    
    for pkg in "${PACOTES_REMOVER[@]}"; do
        printf "  ➔ ${pkg%%\*}... "
        if dpkg -l | grep -q "^ii.*${pkg%%\*}"; then
            # Usando purge para remover completamente os pacotes e arquivos de configuração
            if apt-get purge -y "$pkg" &>/dev/null; then
                printf "${COLOR_SUCCESS}REMOVIDO${COLOR_RESET}\n"
            else
                printf "${COLOR_WARNING}FALHOU${COLOR_RESET}\n"
            fi
        else
            printf "${COLOR_INFO}NÃO INSTALADO${COLOR_RESET}\n"
        fi
    done

    # Remoção especial do Snap
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

    # Limpeza de resíduos
    printf "\n${COLOR_HEADER}LIMPANDO RESÍDUOS DO SISTEMA:${COLOR_RESET}\n"
    
    # Remover pacotes órfãos
    printf "➔ Removendo pacotes órfãos... "
    if apt-get autoremove -y --purge &>/dev/null; then
        printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"
    else
        printf "${COLOR_ERROR}FALHA${COLOR_RESET}\n"
    fi
    
    # Limpar cache
    printf "➔ Limpando cache... "
    apt-get clean &>/dev/null
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* &>/dev/null
    printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"

    printf "\n${COLOR_SUCCESS}✔ Limpeza concluída com sucesso${COLOR_RESET}\n"
    printf "${COLOR_WARNING}⚠ Recomenda-se reiniciar o sistema.${COLOR_RESET}\n"
}

# =================================================⚡
xtdc_install_libreoffice_appimage() {
    # Verificar se é root
    if [[ $EUID -ne 0 ]]; then
        echo "Este script precisa ser executado como root" >&2
        return 1
    fi

    # Configurações
    local LO_URL="https://appimages.libreitalia.org/LibreOffice-fresh.standard-x86_64.AppImage"
    local LO_FILENAME="LibreOffice-fresh.standard-x86_64.AppImage"
    local INSTALL_DIR="/xtdc25/AppImages"
    local DESKTOP_FILE="$HOME/.local/share/applications/libreoffice-appimage.desktop"
    local ICON_URL="https://upload.wikimedia.org/wikipedia/commons/thumb/5/5a/LibreOffice_Main_Logo.png/240px-LibreOffice_Main_Logo.png"
    local ICON_PATH="/usr/share/icons/xtdc_icons/apps/libreoffice.png"

    # MIME types para configurar
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

    # Criar diretório de instalação
    mkdir -p "$INSTALL_DIR" || {
        echo "Erro ao criar diretório $INSTALL_DIR" >&2
        return 1
    }

    # Baixar AppImage
    echo "Baixando LibreOffice AppImage..."
    wget -q --show-progress -O "$INSTALL_DIR/$LO_FILENAME" "$LO_URL" || {
        echo "Erro ao baixar o arquivo" >&2
        return 1
    }

    # Tornar executável
    chmod +x "$INSTALL_DIR/$LO_FILENAME" || {
        echo "Erro ao tornar o AppImage executável" >&2
        return 1
    }

    # Criar diretório de ícones se não existir
    mkdir -p "$(dirname "$ICON_PATH")"

    # Baixar ícone se não existir
    if [[ ! -f "$ICON_PATH" ]]; then
        echo "Baixando ícone do LibreOffice..."
        wget -q -O "$ICON_PATH" "$ICON_URL" || {
            echo "Erro ao baixar o ícone" >&2
            # Não é crítico, então continuamos
        }
    fi

    # Criar arquivo .desktop
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

    # Atualizar banco de dados desktop
    update-desktop-database || {
        echo "Erro ao atualizar o banco de dados de desktop" >&2
        return 1
    }

    # Configurar como aplicativo padrão
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
    # Verificar se é root
    if [[ $EUID -ne 0 ]]; then
        echo "Este script precisa ser executado como root" >&2
        return 1
    fi

    # Configurações
    local GIMP_URL="https://edgeuno-bog2.mm.fcix.net/gimp/gimp/v3.0/linux/GIMP-3.0.4-x86_64.AppImage"
    local GIMP_FILENAME="GIMP-3.0.4-x86_64.AppImage"
    local INSTALL_DIR="/xtdc25/AppImages"
    local DESKTOP_FILE="$HOME/.local/share/applications/gimp-appimage.desktop"
    local ICON_URL="https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/The_GIMP_icon_-_gnome.svg/240px-The_GIMP_icon_-_gnome.svg.png"
    local ICON_PATH="/usr/share/icons/xtdc_icons/apps/gimp.png"

    # MIME types para configurar
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

    # Criar diretório de instalação
    mkdir -p "$INSTALL_DIR" || {
        echo "Erro ao criar diretório $INSTALL_DIR" >&2
        return 1
    }

    # Baixar AppImage
    echo "Baixando GIMP AppImage..."
    wget -q --show-progress -O "$INSTALL_DIR/$GIMP_FILENAME" "$GIMP_URL" || {
        echo "Erro ao baixar o arquivo" >&2
        return 1
    }

    # Tornar executável
    chmod +x "$INSTALL_DIR/$GIMP_FILENAME" || {
        echo "Erro ao tornar o AppImage executável" >&2
        return 1
    }

    # Criar diretório de ícones se não existir
    mkdir -p "$(dirname "$ICON_PATH")"

    # Baixar ícone se não existir
    if [[ ! -f "$ICON_PATH" ]]; then
        echo "Baixando ícone do GIMP..."
        wget -q -O "$ICON_PATH" "$ICON_URL" || {
            echo "Erro ao baixar o ícone" >&2
            # Não é crítico, então continuamos
        }
    fi

    # Criar arquivo .desktop
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

    # Atualizar banco de dados desktop
    update-desktop-database || {
        echo "Erro ao atualizar o banco de dados de desktop" >&2
        return 1
    }

    # Configurar como aplicativo padrão
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

# =================================================⚡
xtdc_tema() {
LIGHTDM_CONF_DIR="/usr/share/lightdm/lightdm-gtk-greeter.conf.d"
printf "\n${COLOR_INFO}➔ Configurando LightDM...${COLOR_RESET}\n"

# Criar arquivo de timestamp
filename=$(date +"%Y_%m_%d_%H_%M_%S").txt && echo "$(date +"%Y-%m-%d %H:%M:%S")" > "$filename"

# Atualizar cache de fontes
sudo fc-cache -f -v

# Remover pacotes Yelp (documentação)
apt purge yelp yelp-xsl

# Atualizar banco de dados de aplicativos
update-desktop-database /etc/skel/.local/share/applications/
}
