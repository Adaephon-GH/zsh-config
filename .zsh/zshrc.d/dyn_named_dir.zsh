__config.git() {
    emulate -L zsh
    setopt extendedglob
    local -a match mbegin mend
    if [[ $1 = d ]]; then
        if [[ $2 = (#b)($HOME/config.git/)([^/]##)-config* ]]; then
            typeset -ga reply
            reply=(c:$match[2] $(( ${#match[1]} + ${#match[2]} + 7 )) )
        else
            return 1
        fi
    elif [[ $1 = n ]]; then
        [[ $2 != (#b)c:(?*) ]] && return 1
        typeset -ga reply
        reply=("${HOME}/config.git/${match[1]}-config")
    elif [[ $1 = c ]]; then
        local expl
        local -a dirs
        dirs=("${HOME}"/config.git/*-config(/:t))
        for (( i=1; i<=$#dirs; i++ )); do
            dirs[$i]=c:${dirs[$i]%-config}
        done
        _wanted dynamic-dirs expl 'dynamic directory' compadd -S\] -a dirs
        return
    else
        return 1
    fi
    return 0
}

__tempdirs() {
    emulate -L zsh
    setopt extendedglob
    setopt nullglob
    local -a match mbegin mend
    if [[ $1 = d ]]; then
        if [[ $2 = (#b)(/tmp/foo/)([^/]##)* ]]; then
            typeset -ga reply
            reply=(foo:$match[2] $(( ${#match[1]} + ${#match[2]} )) )
        else
            return 1
        fi
    elif [[ $1 = n ]]; then
        [[ $2 != (#b)foo:(?*) ]] && return 1
        typeset -ga reply
        reply=("/tmp/foo/${match[1]}")
    elif [[ $1 = c ]]; then
        local expl
        local -a dirs
        dirs=(/tmp/foo/*(/:t))
        for (( i=1; i<=$#dirs; i++ )); do
            dirs[$i]=foo:${dirs[$i]}
        done
        _wanted dynamic-dirs expl 'dynamic directory' compadd -S\] -a dirs
        return
    else
        return 1
    fi
    return 0
}



typeset -a zsh_directory_name_functions
zsh_directory_name_functions=(__config.git __tempdirs)

