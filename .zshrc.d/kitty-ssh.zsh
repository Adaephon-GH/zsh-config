# use kitten ssh (kitty's ssh kitten) instead of plain ssh when inside kitty
if [[ $TERM = xterm-kitty ]]; then
    alias ssh='kitten ssh'

    # kitty's zsh completion function (used for `kitten ssh <TAB>`) aborts
    # with "ZSH anchor based matching active" when an anchor-based
    # matcher-list pass is active (see .zshrc's global matcher-list and
    # https://github.com/kovidgoyal/kitty/discussions/8319). Force plain
    # matching just for kitty's own completion contexts so fuzzy/substring
    # matching keeps working everywhere else.
    zstyle ':completion:*:*:kitten*:*' matcher-list ''
    zstyle ':completion:*:*:kitty*:*' matcher-list ''
    zstyle ':completion:*:*:clone-in-kitty*:*' matcher-list ''
fi
