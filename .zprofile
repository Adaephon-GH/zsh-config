# Set up pyenv
_pyenv_root="${HOME}/local/opt/pyenv"
if [[ -d ${_pyenv_root} && ! -e /tmp/nopyenv ]]; then
    export PYENV_ROOT=$_pyenv_root
    PATH="${PYENV_ROOT}/bin:${PATH}"
    eval "$(${PYENV_ROOT}/bin/pyenv init --path)"
fi
unset _pyenv_root

# automatically start X when logging in on VT1
if [[ -z $DISPLAY && $XDG_VTNR -eq 1 && ! -e /tmp/.X0-lock ]]; then
    exec startx -- -dpi 144
    # export QT_QPA_PLATFORMTHEME=qt6ct
    # exec sway
fi
