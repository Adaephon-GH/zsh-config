# System specific code for Arch

# Use powerpill as download manager for pacman, if available
if [[ -x /usr/bin/powerpill ]]; then
    export PACMAN=/usr/bin/powerpill
fi

# only run this on Arch
if [[ -s '/etc/os-release' ]] && grep -q 'Arch Linux' '/etc/os-release'; then
    if whence pkgfile &> /dev/null; then
        command_not_found_handler() {
            local pkgs cmd="$1"
            pkgs=(${(f)"$(pkgfile -b -v -- "$cmd" 2>/dev/null)"})
            if [[ -n "$pkgs" ]]; then
                printf '%s may be found in the following packages:\n' "$cmd"
                printf '  %s\n' $pkgs[@]
            fi
            printf 'zsh: command not found: %s\n' $cmd
            return 127
        }
    fi
fi


