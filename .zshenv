# .zshenv is sourced for every zsh invocation (login, interactive and scripts),
# so keep it limited to environment that non-interactive shells also benefit
# from. Interactive-only setup (aliases, prompt, completion) lives in .zshrc.

export EDITOR="vim"
export PAGER="less"
export MINICOM="-m -c on"
