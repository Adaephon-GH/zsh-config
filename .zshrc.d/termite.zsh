if [[ $TERM == xterm-termite ]]; then
    . /etc/profile.d/vte.sh
    whence __vte_osc7 > /dev/null && __vte_osc7
fi
