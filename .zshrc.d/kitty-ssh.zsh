# use kitten ssh (kitty's ssh kitten) instead of plain ssh when inside kitty
if [[ $TERM = xterm-kitty ]]; then
    alias ssh='kitten ssh'
fi
