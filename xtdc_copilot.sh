#!/bin/bash

#######################
#    ^...^  `^...^´   #
#   / o,o \ / O,O \   #
#   |):::(| |):::(|   #
# ====" "=====" "==== #
#         TdC         #
#      1998-2026      #
#######################
# Toca das Corujas
# Códigos Binários,
# Funções de Onda e
# Teoria do Orbital Molecular Inc.
# Unidade Barão Geraldo CX
#
# 2026_07_31_20_37_37

set -euo pipefail

# Configuração
CLEAN_FILE="./pkg_limpar.txt"
INSTALL_FILE="./pkg_instalar.txt"
LOGFILE="${HOME:-/tmp}/$(date +'%Y_%m_%d')_pkg_changes.log"

# Colors
COLOR_HEADER='\033[1;36m'
COLOR_SUCCESS='\033[1;32m'
COLOR_ERROR='\033[1;31m'
COLOR_WARNING='\033[1;33m'
COLOR_INFO='\033[1;34m'
COLOR_RESET='\033[0m'

# Helpers
log() {
    echo "[$(date --iso-8601=seconds)] $*" >> "$LOGFILE"
}

_abort() {
    echo -e "${COLOR_ERROR}$*${COLOR_RESET}"
    log "ABORT: $*"
    exit 1
}

_escape_regex() {
    # Escape characters significant to grep -E
    printf '%s' "$1" | sed -e 's/[][^.$*\/]/\\&/g'
}

read_pkg_file() {
    local file="$1"
    local -n out_arr="$2" # nameref
    if [ ! -f "$file" ]; then
        _abort "Arquivo não encontrado: $file"
    fi
    while IFS= read -r line || [ -n "$line" ]; do
        # trim
        line="${line#"${line%%[![:space:]]*}"}"
        line="${line%"${line##*[![:space:]]}"}"
        # skip blank and comments
        [[ -z "$line" || "${line:0:1}" == "#" ]] && continue
        out_arr+=("$line")
    done < "$file"
}

expand_pattern_to_installed() {
    local pattern="$1"
    # if contains wildcard '*', treat as prefix*
    if [[ "$pattern" == *"*"* ]]; then
        local prefix="${pattern%\*}"
        local esc
        esc=$(_escape_regex "$prefix")
        dpkg-query -W -f='${binary:Package}\n' 2>/dev/null | grep -E "^${esc}" || true
    else
        # return pattern if installed (caller will verify installation).
        printf '%s\n' "$pattern"
    fi
}

is_installed() {
    local pkg="$1"
    dpkg-query -W -f='${Status}' "$pkg" 2>/dev/null | grep -q "install ok installed" || return 1
}

unique_array() {
    local -n in="$1"
    local -n out="$2"
    declare -A seen=()
    for v in "${in[@]}"; do
        if [[ -n "$v" && -z "${seen[$v]:-}" ]]; then
            seen[$v]=1
            out+=("$v")
        fi
    done
}

confirm_prompt() {
    local prompt="$1"
    local ans
    read -r -p "$prompt [y/N]: " ans
    case "$ans" in
        [yY]|[yY][eE][sS]) return 0 ;;
        *) return 1 ;;
    esac
}

perform_purge() {
    local -n pkgs="$1"
    if [ "${#pkgs[@]}" -eq 0 ]; then
        echo -e "${COLOR_INFO}Nenhum pacote para remover.${COLOR_RESET}"
        log "Nenhum pacote para remover."
        return
    fi

    echo -e "${COLOR_HEADER}Removendo ${#pkgs[@]} pacotes...${COLOR_RESET}"
    log "Iniciando purge para: ${pkgs[*]}"

    # Use xargs in batches to avoid ARG_MAX issues
    printf '%s\n' "${pkgs[@]}" | xargs -r -n200 apt-get purge -y >> "$LOGFILE" 2>&1 || true
    apt-get autoremove -y >> "$LOGFILE" 2>&1 || true
    apt-get clean >> "$LOGFILE" 2>&1 || true

    # Verify results
    local removed=()
    local failed=()
    for p in "${pkgs[@]}"; do
        if is_installed "$p"; then
            failed+=("$p")
        else
            removed+=("$p")
        fi
    done

    if [ "${#removed[@]}" -gt 0 ]; then
        echo -e "${COLOR_SUCCESS}Removidos: ${removed[*]}${COLOR_RESET}"
        log "Removidos: ${removed[*]}"
    fi
    if [ "${#failed[@]}" -gt 0 ]; then
        echo -e "${COLOR_ERROR}Falha ao remover: ${failed[*]}${COLOR_RESET}"
        log "Falha ao remover: ${failed[*]}"
    fi
}

perform_install() {
    local -n pkgs="$1"
    if [ "${#pkgs[@]}" -eq 0 ]; then
        echo -e "${COLOR_INFO}Nenhum pacote para instalar.${COLOR_RESET}"
        log "Nenhum pacote para instalar."
        return
    fi

    echo -e "${COLOR_HEADER}Instalando ${#pkgs[@]} pacotes...${COLOR_RESET}"
    log "Iniciando install para: ${pkgs[*]}"

    apt-get update >> "$LOGFILE" 2>&1 || true
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends "${pkgs[@]}" >> "$LOGFILE" 2>&1 || true

    # Verify results
    local installed=()
    local failed=()
    for p in "${pkgs[@]}"; do
        if is_installed "$p"; then
            installed+=("$p")
        else
            failed+=("$p")
        fi
    done

    if [ "${#installed[@]}" -gt 0 ]; then
        echo -e "${COLOR_SUCCESS}Instalados: ${installed[*]}${COLOR_RESET}"
        log "Instalados: ${installed[*]}"
    fi
    if [ "${#failed[@]}" -gt 0 ]; then
        echo -e "${COLOR_ERROR}Falha ao instalar: ${failed[*]}${COLOR_RESET}"
        log "Falha ao instalar: ${failed[*]}"
    fi
}

main() {
    if [ "${EUID:-$(id -u)}" -ne 0 ]; then
        _abort "Execute como root (sudo)."
    fi

    log "=== Início do script ==="
    echo -e "${COLOR_HEADER}Arquivo de limpeza: $CLEAN_FILE${COLOR_RESET}"
    echo -e "${COLOR_HEADER}Arquivo de instalação: $INSTALL_FILE${COLOR_RESET}"
    log "Arquivos: limpar=$CLEAN_FILE instalar=$INSTALL_FILE"

    # Read files
    declare -a raw_clean=()
    declare -a raw_install=()
    read_pkg_file "$CLEAN_FILE" raw_clean
    read_pkg_file "$INSTALL_FILE" raw_install

    # Expand patterns and determine actual packages to remove/install
    declare -a want_remove_candidates=()
    for pat in "${raw_clean[@]}"; do
        while IFS= read -r p || [ -n "$p" ]; do
            [[ -z "$p" ]] && continue
            want_remove_candidates+=("$p")
        done < <(expand_pattern_to_installed "$pat")
    done

    # Deduplicate candidates
    declare -a want_remove=()
    unique_array want_remove_candidates want_remove

    # Filter only installed for removal, log those absent
    declare -a final_remove=()
    for p in "${want_remove[@]}"; do
        if is_installed "$p"; then
            final_remove+=("$p")
        else
            log "Ignorado (não instalado): $p"
        fi
    done

    # Install: consider listed packages; skip those already installed
    declare -a final_install=()
    for pat in "${raw_install[@]}"; do
        # support patterns though uncommon for installs
        while IFS= read -r p || [ -n "$p" ]; do
            [[ -z "$p" ]] && continue
            if is_installed "$p"; then
                log "Ignorado (já instalado): $p"
            else
                final_install+=("$p")
            fi
        done < <(expand_pattern_to_installed "$pat")
    done
    declare -a final_install_unique=()
    unique_array final_install final_install_unique
    final_install=("${final_install_unique[@]}")

    # Show and confirm removals
    if [ "${#final_remove[@]}" -gt 0 ]; then
        echo -e "${COLOR_WARNING}Pacotes a REMOVER (${#final_remove[@]}):${COLOR_RESET}"
        printf '%s\n' "${final_remove[@]}"
        if ! confirm_prompt "Confirmar remoção desses pacotes?"; then
            echo "Remoção cancelada pelo usuário."
            log "Remoção cancelada pelo usuário."
        else
            perform_purge final_remove
        fi
    else
        echo -e "${COLOR_INFO}Nenhum pacote para remover.${COLOR_RESET}"
        log "Nenhum pacote para remover após verificação."
    fi

    # Show and confirm installs
    if [ "${#final_install[@]}" -gt 0 ]; then
        echo -e "${COLOR_WARNING}Pacotes a INSTALAR (${#final_install[@]}):${COLOR_RESET}"
        printf '%s\n' "${final_install[@]}"
        if ! confirm_prompt "Confirmar instalação desses pacotes?"; then
            echo "Instalação cancelada pelo usuário."
            log "Instalação cancelada pelo usuário."
        else
            perform_install final_install
        fi
    else
        echo -e "${COLOR_INFO}Nenhum pacote para instalar.${COLOR_RESET}"
        log "Nenhum pacote para instalar após verificação."
    fi

    log "=== Fim do script ==="
    echo -e "${COLOR_SUCCESS}Operação concluída. Ver logs em: $LOGFILE${COLOR_RESET}"
}

main "$@"
