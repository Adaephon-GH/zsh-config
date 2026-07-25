# Commands that provide bash-style completion loaded via bashcompinit,
# i.e. `complete -C <command>`.
() {
    local completion_providers=(terraform mc mcli) cmd
    local -a present
    present=(${(k)commands:*completion_providers})
    (( $#present )) || return
    autoload -U +X bashcompinit && bashcompinit
    for cmd in $present; do
        complete -o nospace -C $commands[$cmd] $cmd
    done
}

# Commands that ship their own zsh completion via
#
#     source <(COMMAND completion zsh)
#
# *and* whose generated completion function is named `_COMMAND`.
# Generate and load it lazily on the first completion attempt so startup
# stays fast. The stub reads its own name from $0 (`_<cmd>` -> `<cmd>`),
# replaces itself with the real completion, then re-dispatches.
() {
    local completion_providers=(helm kubectl k9s exo) cmd
    for cmd in ${(k)commands:*completion_providers}; do
        functions[_$cmd]='
            local _cmd=${0#_}
            unfunction _$_cmd
            source <($_cmd completion zsh)
            _$_cmd "$@"
        '
        compdef _$cmd $cmd
    done
}
