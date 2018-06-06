load_zsl () {
    local ZSL_SCRIPT="${ZDOTDIR:-$HOME}/.zshrc.d/zsh-syntax-highlighting.git/zsh-syntax-highlighting.zsh" 
    if [[ ! -e $ZSL_SCRIPT ]] ; then
        return 1
    fi

    source $ZSL_SCRIPT
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

    ZSH_HIGHLIGHT_STYLES[cursor]='bold'

    ZSH_HIGHLIGHT_STYLES[default]='none'
    ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
    ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=yellow,bold'
    ZSH_HIGHLIGHT_STYLES[alias]='fg=white,bold'
    ZSH_HIGHLIGHT_STYLES[builtin]='fg=white,bold'
    ZSH_HIGHLIGHT_STYLES[function]='fg=white,bold'
    ZSH_HIGHLIGHT_STYLES[command]='fg=white,bold'
    ZSH_HIGHLIGHT_STYLES[precommand]='fg=white,underline'
    ZSH_HIGHLIGHT_STYLES[commandseparator]='none'
    ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=green'
    ZSH_HIGHLIGHT_STYLES[path]='fg=white,bold'
    ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=yellow,bold'
    ZSH_HIGHLIGHT_STYLES[path_approx]='fg=yellow,bold'
    ZSH_HIGHLIGHT_STYLES[globbing]='fg=cyan,bold'
    ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=cyan,bold'
    ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='none'
    ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='none'
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='none'
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow,bold'
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow,bold'
    ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=cyan'
    ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=cyan'
    ZSH_HIGHLIGHT_STYLES[assign]='none'
}

load_fsh () {
    local FSH_SCRIPT="${ZDOTDIR:-$HOME}/.zshrc.d/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" 
    if [[ ! -e $FSH_SCRIPT ]] ; then
        return 1
    fi

    source $FSH_SCRIPT
    return 0
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

    ZSH_HIGHLIGHT_STYLES[cursor]='bold'

    ZSH_HIGHLIGHT_STYLES[default]='none'
    ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
    ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=yellow,bold'
    ZSH_HIGHLIGHT_STYLES[alias]='fg=white,bold'
    ZSH_HIGHLIGHT_STYLES[builtin]='fg=white,bold'
    ZSH_HIGHLIGHT_STYLES[function]='fg=white,bold'
    ZSH_HIGHLIGHT_STYLES[command]='fg=white,bold'
    ZSH_HIGHLIGHT_STYLES[precommand]='fg=white,underline'
    ZSH_HIGHLIGHT_STYLES[commandseparator]='none'
    ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=green'
    ZSH_HIGHLIGHT_STYLES[path]='fg=white,bold'
    ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=yellow,bold'
    ZSH_HIGHLIGHT_STYLES[path_approx]='fg=yellow,bold'
    ZSH_HIGHLIGHT_STYLES[globbing]='fg=cyan,bold'
    ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=cyan,bold'
    ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='none'
    ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='none'
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='none'
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow,bold'
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow,bold'
    ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=cyan'
    ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=cyan'
    ZSH_HIGHLIGHT_STYLES[assign]='none'
}

if ! load_fsh; then
    zle_highlight[(r)default:*]="default:fg=white,bold" 
    zle_highlight[(r)isearch:*]="isearch:fg=yellow,standout,bold"
    zle_highlight[(r)suffix:*]="suffix:fg=magenta,bold"
fi
