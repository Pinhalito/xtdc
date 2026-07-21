#!/bin/bash
#
#
# 2026_07_21_19_42_32

# Definição de cores
COLOR_HEADER='\033[1;36m'
COLOR_SUCCESS='\033[1;32m'
COLOR_ERROR='\033[1;31m'
COLOR_WARNING='\033[1;33m'
COLOR_INFO='\033[1;34m'
COLOR_RESET='\033[0m'

# Garante que o script está rodando como root
if [[ $EUID -ne 0 ]]; then
   echo -e "\033[1;31mEste script precisa ser executado como ROOT (sudo).\033[0m"
   exit 1
fi

# Atualizações iniciais
apt update 
apt upgrade -y
mkdir -p -m 755 /xtdc

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

xtdc_chrome() {
    local CHROME_EXT_DIR="/opt/google/chrome/extensions"

    local -A CHROME_EXT=(
        ["ponfpcnoihfmfllpaingbgckeeldkhle"]="Enhancer for YouTube™"
        ["mnjggcdmjocbbbhaepdhchncahnbgone"]="SponsorBlock para YouTube"
        ["aapbdbdomjkkjkaonfhkkikfgjllcleb"]="Google Tradutor"
        ["gbkeegbaiigmenfmjfclcdgdpimamgkj"]="Editor do Office"      
    )

    printf "${COLOR_HEADER}⚡ INSTALANDO GOOGLE CHROME ⚡${COLOR_RESET}\n\n"

    printf "  ➔ Google Chrome... "
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

    printf "\n➔ EXTENSÕES DO GOOGLE CHROME\n"

    mkdir -p -m 755 "$CHROME_EXT_DIR"

    for ext_id in "${!CHROME_EXT[@]}"; do
        printf "  ➔ ${CHROME_EXT[$ext_id]}... "

        if echo '{ "external_update_url": "https://clients2.google.com/service/update2/crx" }' \
            > "${CHROME_EXT_DIR}/${ext_id}.json"; then
            printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"
        else
            printf "${COLOR_ERROR}FALHA${COLOR_RESET}\n"
        fi
    done

    printf "\n${COLOR_SUCCESS}✔ Instalação concluída com sucesso${COLOR_RESET}\n"
}

xtdc_pkg() {
    local -a PKGS=(
        rclone-browser transmission
        smplayer simplescreenrecorder
        eog shotwell 
        baobab clipit file-roller catfish menulibre
        bleachbit evince geany gnome-disk-utility
        gnome-system-monitor gnome-system-tools gparted
        p7zip-full rar unrar thunar-archive-plugin
        speedcrunch synaptic tree zenity xclip
        language-pack-gnome-pt language-pack-gnome-pt-base language-pack-pt language-pack-pt-base
        gvfs-backends gvfs-fuse samba-libs wmctrl
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
        printf "\n➔ INSTALANDO %d PACOTES\n" "${#to_install[@]}"
        
        if apt-get install -y --no-install-recommends "${to_install[@]}" >/dev/null 2>&1; then
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
        if curl -fsSL https://rclone.org/install.sh | bash >/dev/null 2>&1; then
            printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"
        else
            printf "${COLOR_ERROR}FALHA${COLOR_RESET}\n"
        fi
    else
        printf "${COLOR_INFO}JÁ INSTALADO${COLOR_RESET}\n"
    fi
    
    local BRAVE_EXT_DIR="/opt/brave.com/brave/extensions"
    local -A BRAVE_EXT=(
        ["ponfpcnoihfmfllpaingbgckeeldkhle"]="Enhancer for YouTube™"
        ["mnjggcdmjocbbbhaepdhchncahnbgone"]="SponsorBlock para YouTube"
    )
    
    printf "  ➔ Brave Browser... "
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
    
    printf "\n➔ EXTENSÕES DO BRAVE\n"
    mkdir -p -m 755 "$BRAVE_EXT_DIR" 2>/dev/null
    
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

xtdc_install_libreoffice_appimage() {
    if [[ $EUID -ne 0 ]]; then
        echo "Este script precisa ser executado como root"
        return 1
    fi

    local LO_URL="https://appimages.libreitalia.org/LibreOffice-still.standard-x86_64.AppImage"
    local LO_FILENAME="LibreOffice-still.standard-x86_64.AppImage"
    local INSTALL_DIR="/xtdc/appimages"
    local DESKTOP_FILE="/usr/share/applications/libreoffice-appimage.desktop"

    mkdir -p -m 755 "$INSTALL_DIR" || {
        echo "Erro ao criar diretório $INSTALL_DIR"
        return 1
    }

    echo "Baixando LibreOffice AppImage..."
    wget -q --show-progress -O "$INSTALL_DIR/$LO_FILENAME" "$LO_URL" || {
        echo "Erro ao baixar o arquivo"
        return 1
    }

    chmod +x "$INSTALL_DIR/$LO_FILENAME" || {
        echo "Erro ao tornar o AppImage executável"
        return 1
    }

    echo "Criando arquivo .desktop..."
    cat > "$DESKTOP_FILE" <<'EOL'
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
}

xtdc_tema() {
    local LIGHTDM_CONF_DIR="/usr/share/lightdm/lightdm-gtk-greeter.conf.d"
    
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
}

xtdc_download() {
    apt install -y curl > /dev/null 2>&1
    local GH_URL="https://github.com/Pinhalito/xtdc/raw/refs/heads/main"
    
    local DOWNLOAD_DIR="/xtdc"
    
    mkdir -p -m 755 "$DOWNLOAD_DIR" || {
        printf "${COLOR_ERROR}✖ Falha ao criar diretório ${DOWNLOAD_DIR}${COLOR_RESET}\n"
        return 1
    }
    
    local -a FILE_LIST=(
        "xtdc_icons.tar.gz"
        "xtdc_theme.tar.gz"
        "xtdc_ttf.tar.gz"
        "xtdc"
    )

    printf "${COLOR_HEADER}📦 Iniciando downloads...${COLOR_RESET}\n"
    for file in "${FILE_LIST[@]}"; do
        printf "${COLOR_INFO}➔ Baixando ${file}...${COLOR_RESET}\n"
        curl -sL "${GH_URL}/${file}" -o "${DOWNLOAD_DIR}/${file}" || {
            printf "${COLOR_ERROR}✖ Falha no download de ${file}${COLOR_RESET}\n"
            continue
        }
        printf "${COLOR_SUCCESS}✔ ${file} baixado com sucesso${COLOR_RESET}\n"
    done

    chmod -R u+rwX,go+rX "$DOWNLOAD_DIR" > /dev/null 2>&1
    printf "${COLOR_SUCCESS}✅ Downloads concluídos${COLOR_RESET}\n"
}

xtdc_install() {
    local DOWNLOAD_DIR="/xtdc"
    local -a REQUIRED_FILES=(
        "xtdc_icons.tar.gz"
        "xtdc_theme.tar.gz"
        "xtdc_ttf.tar.gz"
        "xtdc"
    )

    printf "${COLOR_HEADER}📦 Iniciando instalação...${COLOR_RESET}\n"
    
    for file in "${REQUIRED_FILES[@]}"; do
        if [ ! -f "${DOWNLOAD_DIR}/${file}" ]; then
            printf "${COLOR_ERROR}✖ Arquivo ${file} não encontrado em ${DOWNLOAD_DIR}${COLOR_RESET}\n"
            printf "${COLOR_INFO}Execute xtdc_download primeiro para baixar os arquivos.${COLOR_RESET}\n"
            return 1
        fi
    done
    
    printf "${COLOR_INFO}➔ Instalando ícones...${COLOR_RESET}\n"
    tar -xzf "${DOWNLOAD_DIR}/xtdc_icons.tar.gz" -C /usr/share/icons/ || {
        printf "${COLOR_ERROR}✖ Falha ao descompactar ícones${COLOR_RESET}\n"
        return 1
    }
    
    printf "${COLOR_INFO}➔ Instalando temas...${COLOR_RESET}\n"
    tar -xzf "${DOWNLOAD_DIR}/xtdc_theme.tar.gz" -C /usr/share/themes/ || {
        printf "${COLOR_ERROR}✖ Falha ao descompactar temas${COLOR_RESET}\n"
        return 1
    }
    
    printf "${COLOR_INFO}➔ Instalando fontes...${COLOR_RESET}\n"
    tar -xzf "${DOWNLOAD_DIR}/xtdc_ttf.tar.gz" -C /usr/share/fonts/truetype/ || {
        printf "${COLOR_ERROR}✖ Falha ao descompactar fontes${COLOR_RESET}\n"
        return 1
    }
    
    printf "${COLOR_INFO}➔ Instalando executável...${COLOR_RESET}\n"
    mv "${DOWNLOAD_DIR}/xtdc" /bin/ || {
        printf "${COLOR_ERROR}✖ Falha ao mover o executável${COLOR_RESET}\n"
        return 1
    }
    
    chmod 755 /bin/xtdc || {
        printf "${COLOR_ERROR}✖ Falha ao definir permissões do executável${COLOR_RESET}\n"
        return 1
    }
    
    if command -v fc-cache >/dev/null 2>&1; then
        printf "${COLOR_INFO}➔ Atualizando cache de fontes...${COLOR_RESET}\n"
        fc-cache -f > /dev/null 2>&1
    fi
    
    printf "${COLOR_SUCCESS}✅ Instalação concluída com sucesso${COLOR_RESET}\n"
    printf "${COLOR_INFO}Os seguintes itens foram instalados:\n"
    printf "  • Ícones: /usr/share/icons/xtdc_icons e /usr/share/icons/xtdc_svg\n"
    printf "  • Temas: /usr/share/themes/xtdc_theme e /usr/share/themes/xtdc_dark\n"
    printf "  • Fontes: /usr/share/fonts/truetype/xtdc_ttf\n"
    printf "  • Executável: /bin/xtdc (com permissões 755)${COLOR_RESET}\n"
    
    rm -rf /xtdc/*.tar.gz
}

xtdc_limpeza() {
    local -a PACOTES_REMOVER=(
        snapd apport apport-symptoms thunderbird aspell
        "libreoffice-*"
        gnome-mahjongg gnome-sudoku gnome-mines aisleriot
        bluetooth bluez cups-browsed printer-driver-*
        "zeitgeist*"
        fonts-tlwg-garuda fonts-tlwg-garuda-ttf fonts-tlwg-kinnari fonts-tlwg-kinnari-ttf
        fonts-tlwg-laksaman fonts-tlwg-laksaman-ttf fonts-tlwg-loma fonts-tlwg-loma-ttf
        fonts-tlwg-mono fonts-tlwg-mono-ttf fonts-tlwg-norasi fonts-tlwg-norasi-ttf
        fonts-tlwg-purisa fonts-tlwg-purisa-ttf fonts-tlwg-sawasdee fonts-tlwg-sawasdee-ttf
        fonts-tlwg-typewriter fonts-tlwg-typewriter-ttf fonts-tlwg-typist fonts-tlwg-typist-ttf
        fonts-tlwg-typo fonts-tlwg-typo-ttf fonts-tlwg-umpush fonts-tlwg-umpush-ttf
        fonts-tlwg-waree fonts-tlwg-waree-ttf
        cheese deja-dup duplicity gnome-characters gnome-font-viewer
        gnome-initial-setup gnome-logs gnome-online-accounts
        gnome-software-plugin-snap openvpn remmina rhythmbox
        totem shotwell ubuntu-docs usb-creator-gtk
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
    
    if ! command -v apt-get &>/dev/null || ! command -v dpkg &>/dev/null; then
        printf "${COLOR_ERROR}✖ Erro: Sistema de pacotes não encontrado${COLOR_RESET}\n"
        return 1
    fi

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
    
    rm -rf /usr/share/fonts/truetype/tlwg
}

# Criação do arquivo de log
NOW=$(date +'%Y_%m_%d_%H_%M_%S')
LOG_FILE="/xtdc/xtdc_log_${NOW}.txt"

{
    echo "$NOW"
    echo "=== XTDC Setup Log ==="
} > "$LOG_FILE"

chmod 644 "$LOG_FILE"

# Descomentar para executar automaticamente:
# printf "${COLOR_HEADER}🚀 Iniciando Automação XTDC...${COLOR_RESET}\n"
# xtdc_ppa
# xtdc_pkg
# xtdc_chrome
# xtdc_download
# xtdc_install
# xtdc_install_libreoffice_appimage
# xtdc_tema
# xtdc_limpeza
# printf "${COLOR_SUCCESS}🎉 Todo o processo foi concluído. Log salvo em: $LOG_FILE${COLOR_RESET}\n"
# printf "${COLOR_WARNING}⚠ Recomenda-se reiniciar o sistema.${COLOR_RESET}\n"

# FIM
