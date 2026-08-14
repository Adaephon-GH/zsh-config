# .zshenv is sourced for every zsh invocation (login, interactive and scripts),
# so keep it limited to environment that non-interactive shells also benefit
# from. Interactive-only setup (aliases, prompt, completion) lives in .zshrc.

export EDITOR="vim"
export PAGER="less"
export MINICOM="-m -c on"

# Ubuntu's /etc/zsh/zshrc runs compinit *before* ~/.zshrc is read -- i.e. before
# .zshrc puts the submodule completion directories on $fpath -- so the dump it
# writes is missing those completions. compinit reuses a dump whenever the file
# count recorded in it matches $fpath, so the two runs disagree and overwrite
# each other's dump on every shell start, and .zshrc's `compinit -C` keeps
# loading the wrong one. Completion setup belongs to .zshrc alone.
# (Not exported: /etc/zsh/zshrc tests a plain shell parameter. Harmless on
# distributions whose /etc/zsh/zshrc does not call compinit at all.)
skip_global_compinit=1
