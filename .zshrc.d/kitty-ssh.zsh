# use kitten ssh (kitty's ssh kitten) instead of plain ssh when inside kitty
if [[ $TERM = xterm-kitty ]]; then
    # A function (not an alias) so that zsh's completion system still sees
    # the literal command name `ssh` and uses the stock `_ssh` completion.
    # An alias here would be textually expanded to `kitten ssh ...` before
    # completion runs, causing kitty's own `_kitty`/`kitten` completion to
    # run instead — which aborts with "ZSH anchor based matching active"
    # whenever fuzzy/substring host matching is attempted (see
    # https://github.com/kovidgoyal/kitty/discussions/8319).
    ssh() { kitten ssh "$@" }
fi
