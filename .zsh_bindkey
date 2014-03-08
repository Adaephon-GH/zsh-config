bindkey -e

# ^X : Strg-x
# ^[x : Esc+x, Alt-x
# ^[X : Esc+Shift-x, Alt-Shift-x
# ^Xa : Strg-X+a

bindkey "^[[Z" reverse-menu-complete
bindkey "^[[5~" history-beginning-search-backward
bindkey "^[[6~" history-beginning-search-forward
bindkey "^[r" history-incremental-search-forward

bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word

# Home
bindkey "^[OH" beginning-of-line
bindkey "^[[H" beginning-of-line
bindkey "^[[7~" beginning-of-line
# End
bindkey "^[OF" end-of-line
bindkey "^[[F" end-of-line
bindkey "^[[8~" end-of-line

# KP Enter
bindkey "^[OM" accept-line

# Del
bindkey "^[[3~" delete-char
# Insert
bindkey "^[[2~" overwrite-mode

bindkey "^[m" set-mark-command

bindkey "^X^R" _read_comp
bindkey "^X?" _complete_debug
bindkey "^XC" _correct_filename
bindkey "^Xa" _expand_alias
bindkey "^Xc" _correct_word
bindkey "^Xd" _list_expansions
bindkey "^Xe" _expand_word
bindkey "^Xh" _complete_help
bindkey "^Xm" _most_recent_file
bindkey "^Xn" _next_tags
bindkey "^Xt" _complete_tag
bindkey "^X~" _bash_list-choices
bindkey "^[," _history-complete-newer
bindkey "^[/" _history-complete-older
bindkey "^[~" _bash_complete-word

bindkey "^[#" pound-insert
bindkey "^Q" push-line-or-edit
bindkey "^[q" push-line-or-edit
bindkey "^[Q" push-line-or-edit

bindkey "^[^[" vi-cmd-mode
bindkey -a "^[^[" vi-add-next

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^[v" edit-command-line
bindkey -a "v" edit-command-line

bindkey '^P' predict-toggle

fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    echo
    bg
    echo
    zle redisplay
  else
    zle push-input
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z
