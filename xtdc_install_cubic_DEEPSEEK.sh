#!/bin/bash

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
# FUNÇÃO PARA ADICIONAR PPAS
# =================================================⚡
xtdc_ppa() {
    # Lista consolidada de PPAs para adicionar
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

    printf "${COLOR_HEADER}⚡ ADICIONANDO PPAS ⚡${COLOR_RESET}\n\n"
    local needs_update=0

    for ppa in "${PPAS[@]}"; do
        printf "  ➔ %-40s" "$ppa..."
        
        # Verifica se o PPA já existe
        if ! grep -rq "$ppa" /etc/apt/sources.list /etc/apt/sources.list.d/; then
            if add-apt-repository -y "ppa:$ppa" >/dev/null 2>&1; then
                printf "${COLOR_SUCCESS}ADICIONADO${COLOR_RESET}\n"
                needs_update=1
            else
                printf "${COLOR_ERROR}FALHOU${COLOR_RESET}\n"
                continue
            fi
        else
            printf "${COLOR_INFO}JÁ EXISTE${COLOR_RESET}\n"
        fi
    done

    # Atualiza apenas se novos PPAs foram adicionados
    if [ "$needs_update" -eq 1 ]; then
        printf "\n➔ Atualizando lista de pacotes... "
        if apt-get update -qq; then
            printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"
        else
            printf "${COLOR_ERROR}FALHA${COLOR_RESET}\n"
            return 1
        fi
    else
        printf "\n${COLOR_INFO}✔ Nenhum novo PPA para adicionar${COLOR_RESET}\n"
    fi
}

# =================================================⚡
# FUNÇÃO PRINCIPAL DE INSTALAÇÃO DE PACOTES
# =================================================⚡
xtdc_pkg() {
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
            # Tentativa alternativa com continuação em caso de erros
            printf "  ➔ Tentando instalação individual...\n"
            for pkg in "${to_install[@]}"; do
                printf "    ➔ %-30s" "$pkg..."
                if apt-get install -y --no-install-recommends "$pkg" >/dev/null; then
                    printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"
                else
                    printf "${COLOR_ERROR}FALHA${COLOR_RESET}\n"
                fi
            done
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
# FUNÇÃO DE LIMPEZA DO SISTEMA
# =================================================⚡
xtdc_limpeza() {
    declare -a PACOTES_REMOVER=(
        snapd gnome-software-plugin-snap 
        libreoffice-*
        gnome-mahjongg gnome-sudoku gnome-mines aisleriot
        bluetooth bluez* cups cups-browsed printer-driver-*
        zeitgeist* apport apport-symptoms thunderbird
        cheese deja-dup duplicity gnome-characters gnome-font-viewer
        gnome-initial-setup gnome-logs gnome-online-accounts
        gnome-software-plugin-snap openvpn* remmina rhythmbox
        totem shotwell ubuntu-docs usb-creator-gtk yelp yelp-xsl
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
# FUNÇÃO PARA CONFIGURAÇÃO DE TEMA
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

            # Configuração para Xubuntu
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

    # Configurações adicionais de tema
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
# CHAMADA PRINCIPAL (EXEMPLO)
# =================================================⚡
# xtdc_ppa
# xtdc_pkg
# xtdc_limpeza
# xtdc_tema
