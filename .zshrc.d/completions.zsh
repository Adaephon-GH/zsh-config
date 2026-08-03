# Completion for commands that act as their own completion helper, i.e. that
# ask to be registered in bash as
#
#     complete [-o nospace] -C <helper> <command>
#
# -- the helper is an *external command* which bash runs and whose output it
# reads as the candidate list.  This is what `mc --autocompletion` and
# `terraform -install-autocomplete` emit.
#
# This covers that one registration form and nothing else.  Bash's
# function-based completions (`complete -F <shell-function>`, which is what
# most bash-completion scripts use) and the remaining `complete`/`compgen`
# options still need zsh's `bashcompinit`; the two are complementary, so load
# `bashcompinit` alongside this if such a script is ever added.
#
# Why not let `bashcompinit` handle `-C` too: its `compgen -C` implementation
# runs the helper with *no* arguments and word-splits the output on every
# space (the `C)` branch in Completion/bashcompinit), whereas bash passes
# three arguments -- $1 the command word, $2 the word being completed, $3 the
# word before it -- and splits on newlines only.  `mc` refuses to enter
# completion mode unless $1 is its own name, so under `bashcompinit` it just
# printed its help text and zsh offered every word of that help as a
# candidate.  Calling the helper the way bash does fixes `mc`, and
# line-splitting keeps candidates containing spaces (`mc` completes local
# file names) in one piece.
typeset -gA _bash_complete_C_helpers

_bash_complete_C() {
    local cmd=$words[1]
    local helper=${_bash_complete_C_helpers[$cmd]:-$commands[$cmd]}
    [[ -n $helper ]] || return 1

    # Same command line / cursor position reconstruction bashcompinit uses.
    local -x COMP_LINE="$words"
    local -x COMP_POINT
    (( COMP_POINT = 1 + ${#${(j. .)words[1,CURRENT-1]}} + $#QIPREFIX + $#IPREFIX + $#PREFIX ))

    local -a candidates
    candidates=( ${(f)"$($helper $cmd ${words[CURRENT]} ${words[CURRENT-1]} 2>/dev/null)"} )
    (( $#candidates )) || return 1

    # The helper has already filtered by prefix, so add the results as they
    # are.  A trailing slash means the word is not finished yet (aliases,
    # buckets, directories) -- suppress the space there, as `-o nospace` did.
    local expl ret=1
    _description values expl "$cmd completion"
    compadd "$expl[@]" -S '' -- ${(M)candidates:#*/} && ret=0
    compadd "$expl[@]"       -- ${candidates:#*/}    && ret=0
    return ret
}

# Commands whose own executable is the `complete -C` helper.
() {
    local completion_providers=(terraform mc mcli) cmd
    for cmd in ${(k)commands:*completion_providers}; do
        _bash_complete_C_helpers[$cmd]=$commands[$cmd]
        compdef _bash_complete_C $cmd
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
