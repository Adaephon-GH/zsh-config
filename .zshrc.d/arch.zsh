# System specific code for Arch

# Use powerpill as download manager for pacman, if available
if [[ -x /usr/bin/powerpill ]]; then
    export PACMAN=/usr/bin/powerpill
fi

# only run this on Arch
if [[ -s '/etc/os-release' ]] && grep -q 'Arch Linux' '/etc/os-release'; then
    if [[ -s '/usr/share/doc/pkgfile/command-not-found.zsh' ]]; then
        source '/usr/share/doc/pkgfile/command-not-found.zsh'
    fi
fi


