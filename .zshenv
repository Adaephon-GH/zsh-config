# Use powerpill as download manager for pacman, if available
if [[ -x /usr/bin/powerpill ]]; then
    export PACMAN=/usr/bin/powerpill
fi


