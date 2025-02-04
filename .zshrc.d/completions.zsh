# Commands that provide completion via bashcompinit
() {
    local completion_providers=(terraform mc mcli)
    if [[ ${#${(k)commands:*completion_providers}} == 0 ]]; then
        return
    fi
    autoload -U +X bashcompinit && bashcompinit
    for cmd in ${(k)commands:*completion_providers}; do
        complete -o nospace -C $commands[$cmd] $cmd
    done
}


autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /home/mruf/.local/bin/mc mc
# Completion for commands that provide their own completion via
#
#     source <(COMMAND completion zsh)
#
# *and* where the generated completion has the name '_COMMAND'.
#
() {
    local completion_providers=(helm kubectl k9s exo)
    for cmd in ${(k)commands:*completion_providers}; do
        _$cmd () {
            source <($cmd completion zsh)
            _$cmd $@
        }
        compdef _$cmd $cmd
    done
}

