# automatically start X when logging in on VT1
if [[ -z $DISPLAY && $XDG_VTNR -eq 1 && ! -e /tmp/.X0-lock ]]; then
    exec startx
fi
