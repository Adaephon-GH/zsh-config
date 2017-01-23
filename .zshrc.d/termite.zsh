VTE_SH=/etc/profile.d/vte.sh
if [[ $TERM == xterm-termite && -e $VTE_SH ]]; then
    . $VTE_SH
    whence __vte_osc7 > /dev/null && __vte_osc7
fi
unset VTE_SH
