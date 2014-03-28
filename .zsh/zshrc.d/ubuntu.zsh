# System specific code for Ubuntu

# exit if this is not an ubuntu
if [[ -s '/etc/os-release' ]] && grep -q ubuntu '/etc/os-release'; then
    if [[ -s '/etc/zsh_command_not_found' ]]; then
        source '/etc/zsh_command_not_found'
    fi
fi


