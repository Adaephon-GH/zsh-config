# Terraform
if [[ $commands[terraform] ]]; then
    autoload -U +X bashcompinit && bashcompinit
    complete -o nospace -C $commands[terraform] terraform
fi

# Completion for commands that provide their own completion via
#     COMMAND completion zsh
() {
    local completion_providers=(helm kubectl k9s)
    for cmd in ${(k)commands:*completion_providers}; do
        _$cmd () {
            source <($cmd completion zsh)
            _$cmd $@
        }
        compdef _$cmd $cmd
    done
}

