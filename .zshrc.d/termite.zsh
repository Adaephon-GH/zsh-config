VTE_SH=/etc/profile.de/vte.sh
if [[ $TERM == xterm-termite ]]; then
    if [[ -e $VTE_SH ]]; then
        . $VTE_SH
        whence __vte_osc7 > /dev/null && __vte_osc7
    fi
fi
unset VTE_SH
