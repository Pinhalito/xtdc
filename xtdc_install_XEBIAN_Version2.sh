xtdc_limpeza(){
    printf "${COLOR_HEADER}LIMPEZA DO SISTEMA${COLOR_RESET}\n\n"

    printf "Atualizando lista de pacotes..."
    if apt-get update -qq &>/dev/null; then
        printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"
    else
        printf "${COLOR_ERROR}FALHA${COLOR_RESET}\n"
        return 1
    fi

    printf "\n${COLOR_HEADER}REMOVENDO PACOTES DESNECESSÁRIOS:${COLOR_RESET}\n"

    for pkg in "${PACOTES_REMOVER[@]}"; do
        if dpkg -l 2>/dev/null | grep -q "^ii.*${pkg}"; then
            printf "%s..." "$pkg"
            if apt-get purge -y "$pkg" &>/dev/null; then
                printf "${COLOR_SUCCESS}REMOVIDO${COLOR_RESET}\n"
            else
                printf "${COLOR_WARNING}FALHOU${COLOR_RESET}\n"
            fi
        fi
    done

    if dpkg -l snapd &>/dev/null; then
        printf "\nRemovendo Snap completamente..."
        systemctl stop snapd.socket snapd.service 2>/dev/null || true
        if apt-get purge -y snapd gnome-software-plugin-snap &>/dev/null; then
            rm -rf /snap /var/snap /var/lib/snapd ~/snap &>/dev/null
            printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"
        else
            printf "${COLOR_ERROR}FALHA${COLOR_RESET}\n"
        fi
    fi

    printf "\n${COLOR_HEADER}LIMPANDO RESÍDUOS DO SISTEMA:${COLOR_RESET}\n"
    printf "Removendo pacotes órfãos..."
    apt-get autoremove -y --purge &>/dev/null || true
    printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"

    printf "Limpando cache..."
    apt-get clean &>/dev/null
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/* &>/dev/null
    printf "${COLOR_SUCCESS}OK${COLOR_RESET}\n"
}