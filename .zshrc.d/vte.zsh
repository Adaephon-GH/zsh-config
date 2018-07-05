VTE_SH=/etc/profile.d/vte.sh
if [[ -e $VTE_SH ]]; then
    . $VTE_SH
fi
unset VTE_SH
