xtdc_tema(){
    if [ -n "${LIGHTDM_CONF_DIR}" ] && [ -d /usr/share/lightdm ]; then
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
    else
        printf "${COLOR_INFO}LightDM não detectado; pulando configuração do greeter.${COLOR_RESET}\n"
    fi

    ...
}