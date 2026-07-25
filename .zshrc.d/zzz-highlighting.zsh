# Fast Syntax Highlighting (F-Sy-H)
#   https://github.com/zdharma-continuum/fast-syntax-highlighting
# When the submodule is not checked out, fall back to zsh's built-in
# zle_highlight so the line editor is still readable.
load_fsh () {
    local dir="${ZDOTDIR:-$HOME}/.zshrc.d/fast-syntax-highlighting"
    local script
    # zdharma-continuum ships fast-syntax-highlighting.plugin.zsh; the older
    # zdharma layout used F-Sy-H.plugin.zsh. Accept whichever is present.
    for script in \
        "$dir/fast-syntax-highlighting.plugin.zsh" \
        "$dir/F-Sy-H.plugin.zsh"
    do
        if [[ -r $script ]]; then
            source "$script"
            # vim's chroma is noisy on the command line; disable just that one.
            unset "FAST_HIGHLIGHT[chroma-vim]"
            return 0
        fi
    done
    return 1
}

if ! load_fsh; then
    zle_highlight[(r)default:*]="default:fg=white,bold"
    zle_highlight[(r)isearch:*]="isearch:fg=yellow,standout,bold"
    zle_highlight[(r)suffix:*]="suffix:fg=magenta,bold"
fi
