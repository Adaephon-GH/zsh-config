# vim: fmr={{{,}}} fdm=marker cms=#\ %s :

# load dircolors here
if [ -x /usr/bin/dircolors ]; then
    test -r ${HOME}/.dircolors && eval "$(dircolors -b ${HOME}/.dircolors)" || eval "$(dircolors -b)"
fi

# addons
autoload -Uz zcalc
autoload -Uz zmv
autoload -Uz add-zsh-hook
autoload -Uz add-zle-hook-widget

# {{{ Completion
# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _approximate
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' file-sort name
zstyle ':completion:*' format '%F{blue}%U>>> %d%u%f'
zstyle ':completion:*' group-name ''
#zstyle ':completion:*' ignore-parents parent pwd .. directory
zstyle ':completion:*:(cd|mv|cp):*' ignore-parents parent pwd
zstyle ':completion:*:*:-command-:*:*' ignored-patterns '_*'
zstyle ':completion:*:complete:-tilde-:*' tag-order 'named-directories directory-stack' users
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' 'r:|[._-]=* r:|=*' '+m:{[:lower:]}={[:upper:]}' 'l:|=* r:|=*'
zstyle ':completion:*' max-errors 1 numeric
zstyle ':completion:*' menu select=1
zstyle ':completion:*' original true
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' rehash true
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' verbose true
zstyle :compinstall filename "${ZDOTDIR:-$HOME}/.zshrc"

# Completion-function directories shipped as submodules (e.g. timewarrior)
# must be on $fpath *before* compinit scans it.
typeset -U fpath
fpath+=( ${ZDOTDIR:-$HOME}/.zshrc.d/*/_*(N:h) )

# Run compinit once. Rebuild and security-audit the dump at most once a day;
# otherwise trust the existing dump (compinit -C) for a faster startup.
autoload -Uz compinit
() {
    local -a stale=( ${ZDOTDIR:-$HOME}/.zcompdump(N.mh+24) )
    if (( $#stale )); then
        compinit
    else
        compinit -C
    fi
}
# End of lines added by compinstall

# Additional completion configuration
# for killall
zstyle ':completion:*:processes-names' command 'ps -e -o comm='
# for kill
zstyle ':completion:*:processes' command 'ps -a -u $USER -H -o pid,tty,time,command'
zstyle ':completion:*:processes' list-colors '=(#b) #([0-9]#)*=0=00;32'

ZSH_SPACE_SUFFIX_CHARS=$'|&'

setopt magicequalsubst
setopt globcomplete
# }}}

# {{{ General options: Globbing, History

# globbing
autoload -Uz age
setopt extendedglob
setopt globstarshort
setopt braceccl

# commandline behaviour
setopt autocd
DIRSTACKSIZE=16
setopt autopushd
setopt pushdminus
setopt pushdignoredups

## History control
HISTFILE=${ZDOTDIR:-$HOME}/.histfile
HISTSIZE=10000
SAVEHIST=10000
# either incappendhistory or sharehistory
setopt incappendhistory
#setopt sharehistory
setopt extendedhistory
setopt histnostore
setopt histreduceblanks
setopt histignorespace
setopt histignorealldups
# }}}

## I/O
unsetopt beep
setopt interactivecomments
setopt rematchpcre
setopt noclobber
setopt appendcreate

## job control
setopt autocontinue

## prompt
setopt promptsubst
setopt promptpercent

# {{{ $terminfo helper functions
# Make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
# These are just helper functions that have to be added to
# zle-line-init and zle-line-finish respectively
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    enter-kbd-transmit-mode () {
        emulate -L zsh
        printf '%s' ${terminfo[smkx]}
    }
    leave-kbd-transmit-mode () {
        emulate -L zsh
        printf '%s' ${terminfo[rmkx]}
    }
else
    enter-kbd-transmit-mode leave-kbd-transmit-mode () { : }
fi
# }}}

# {{{ prompt formats for vcs information
### VCS INFORMATION
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable cvs git hg svn
## general settings
zstyle ':vcs_info:*' disable-patterns "/(mnt|misc)(|/*)"
zstyle ':vcs_info:*' actionformats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%r/%B%b%%b%F{3}|%F{1}%a%F{5}]%f'
zstyle ':vcs_info:*' formats       '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%r/%B%b%%b%F{5}]%f'

zstyle ':vcs_info:(sv[nk]|bzr|hg*):*' branchformat '%B%b%%b%F{1}:%F{3}%r'

## Mercurial and Git
zstyle ':vcs_info:(hg*|git*):*' get-revision true
zstyle ':vcs_info:(hg*|git*):*' check-for-changes true
zstyle ':vcs_info:(hg*|git*):*' unstagedstr "!"
zstyle ':vcs_info:(hg*|git*):*' stagedstr "+"

#  Mercurial rev+changes branch misc
zstyle ':vcs_info:hg*' formats "%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%r/%b %F{11}%c%u %F{1}%m%F{5}]%f"
zstyle ':vcs_info:hg*' actionformats "%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%r/%b %F{11}%u %F{1}%m%F{3}|%F{1}%a%F{5}]%f"
zstyle ':vcs_info:hg*:*' get-bookmarks true
zstyle ':vcs_info:hg*:*' get-mq true
zstyle ':vcs_info:hg*:*' get-unapplied true
zstyle ':vcs_info:hg*:*' patch-format "mq(%g):%n/%c %p"
zstyle ':vcs_info:hg*:*' nopatch-format "mq(%g):%n/%c %p"
zstyle ':vcs_info:hg*:*' hgrevformat '%F{11}%r%F{1}:%F{3}%12.12h'

# Git hash changes branch misc
+vi-git-untracked(){
    # vcs_info only runs this hook inside a git repo, so no work-tree probe is
    # needed here. stderr is silenced for the rare case of being inside .git/.
    local staged unstaged untracked

    local -A counts
    counts=(
        $(git status --porcelain 2>/dev/null | awk '
            BEGIN {st=0; us=0; ut=0}
            /^[MADRC]/ {st+=1}
            /^.[MD]/ {us+=1}
            /^\?\?/ {ut+=1}
            END {print "staged", st, "unstaged", us, "untracked", ut}'
            ))
    
    if [[ ${counts[staged]} -gt 1 ]]; then
        hook_com[staged]+="${counts[staged]} "
    fi

    if [[ ${counts[unstaged]} -gt 1 ]]; then
        hook_com[unstaged]+="${counts[unstaged]} "
    fi

    if [[ ${counts[untracked]} -gt 0 ]]; then
        hook_com[unstaged]+='?'
        if [[ ${counts[untracked]} -gt 1 ]]; then
            hook_com[unstaged]+="${counts[untracked]}"
        fi
    fi
}

zstyle ':vcs_info:git+set-message:*' hooks git-untracked
zstyle ':vcs_info:git*' formats "%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%r/%B%b%%b%F{1}:%F{3}%10.10i %F{11}%c%u %F{1}%m%F{5}]%f"
zstyle ':vcs_info:git*' actionformats "%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%B%r/%b%%b%F{1}:%F{3}%10.10i %F{11}%c%u %F{1}%m%F{5}|%F{1}%a%F{5}]%f"
zstyle ':vcs_info:git*' branchformat "%b:%r"
zstyle ':vcs_info:git*' get-unapplied true
zstyle ':vcs_info:git*' patch-format "%p:%n/%c %p"
zstyle ':vcs_info:git*' nopatch-format "%p:%n/%c %p"

add-zsh-hook precmd vcs_info
# }}}

# {{{ indicator for python virtual environments
# Prevent virtualenv from setting prompt on its own
export VIRTUAL_ENV_DISABLE_PROMPT=yes

pyenv_indicator () {
    local version file origin

    # fallback in case pyenv is not installed
    if [[ -z $PYENV_ROOT ]]; then
        if [[ -z $VIRTUAL_ENV ]]; then
            psvar[1]=''
        else
            psvar[1]=${VIRTUAL_ENV##*/}
        fi
        return
    fi

    # Explicitly set virtual envs have priority over anythin set by pyenv
    version=(${VIRTUAL_ENV##*/} ${(s.:.)$(pyenv version-name)})
    version=${version:#system}

    # Hide indicator and avoid extra work if there are no versions to show
    if [[ -z $version ]]; then
        psvar[1]=""
        return
    fi

    if [[ -n $VIRTUAL_ENV ]]; then
        # A non-pyenv virtual env is active
        origin="v"
    elif [[ -n $PYENV_VERSION ]]; then
        # pyenv was configured on a shell level
        origin="s"
    else
        file=$(pyenv version-file)
        if [[ $file != "$PYENV_ROOT/version" ]]; then
            # pyenv was configured by .python-version in some (parent-)directory
            origin="l"
        else
            # pyenv uses global settings
            origin="g"
        fi
    fi

    psvar[1]=" $version |$origin"
}

add-zsh-hook precmd pyenv_indicator
# }}}

# {{{ function to determine if login is local or remote
# Flag network logins so the prompt (psvar[2]) can mark them -- important so a
# stray `poweroff` is never run on a remote host mistaken for the local one.
#
# Checked cheapest first:
#   1. The SSH_* variables sshd exports into the session environment.
#   2. Otherwise walk the process-tree ancestry via /proc -- no forks, unlike
#      the old `ps`-per-level version -- looking for a remote-access daemon.
#      This also catches `su -`, which scrubs the SSH_* variables but leaves the
#      shell parented under sshd / mosh-server / telnetd / rlogind.
# logintype runs once per shell startup, so the walk is negligible.
#
# Limitation: a strict `hidepid` mount on /proc can hide an ancestor owned by
# another user and stop the walk early; the SSH_* check still covers the common
# direct-login case, and on non-Linux systems (no /proc) only step 1 applies.
logintype () {
    emulate -L zsh
    if [[ -n $SSH_CONNECTION || -n $SSH_CLIENT || -n $SSH_TTY ]]; then
        print remote
        return
    fi

    local pid=$PPID comm line after
    local -a fields
    while (( pid > 1 )) && [[ -r /proc/$pid/stat ]]; do
        line=$(</proc/$pid/stat)
        # comm sits between the first '(' and the last ')'; later stat fields
        # are numeric, so the last ')' in the line is always comm's close.
        comm=${${line%\)*}#*\(}
        case $comm in
            (*sshd*|mosh-server|*telnetd|*rlogind)
                print remote
                return
                ;;
        esac
        after=${line##*\) }          # "state ppid pgrp ..."
        fields=( ${(s: :)after} )
        (( pid == fields[2] )) && break
        pid=$fields[2]
    done
    print local
}
psvar[2]=${$(logintype)#local}

# }}}

# {{{ get exit codes of previous command or pipeline
pipestatus () {
    pipestatus_=($pipestatus)
    pipestatuscolor='%K{green}%F{black}'
    local ec
    for (( ec=1 ; ec <= $#pipestatus_ ; ec++ )) do
        if [ $pipestatus_[ec] -eq 0 ] ; then
            pipestatus_[ec]="ok"
        else
            pipestatuscolor='%K{yellow}%F{black}' 
            if [ $pipestatus_[ec] -gt 128 ] ; then
                pipestatus_[ec]=$(kill -l $pipestatus_[ec])
            fi
        fi
    done
    pipestatus_str="$pipestatus_"
    unset pipestatus_
  
}

add-zsh-hook precmd pipestatus
# }}}

# {{{ indicator whether zle is in vicmd mode
vicmdindicator=' '
# Registered as a keymap-select hook (see below). The DECSCUSR cursor-shape
# sequences are skipped on the Linux console, which does not understand them.
vicmd-indicator () {
    case $KEYMAP in
        vicmd)
            vicmdindicator='%S%Bv%s'
            [[ $TERM == linux ]] || print -n '\e[2 q'
            ;;
        *)
            vicmdindicator=' '
            [[ $TERM == linux ]] || print -n '\e[0 q'
            ;;
    esac
    zle reset-prompt
}
zle -N vicmd-indicator
add-zle-hook-widget keymap-select vicmd-indicator
# }}}

# {{{ set alert on terminals after long running processes finish and log running time
typeset -i LONGRUNTIME=60
typeset -F SECONDS
typeset -F 1 cmd_starttime cmd_runtime

save_starttime () {
    cmd_starttime=$SECONDS
}

set_longrunning_alert () {
    cmd_runtime=SECONDS-cmd_starttime
    if ((cmd_runtime >= LONGRUNTIME)); then
        print "\a"
    fi
}

add-zsh-hook preexec save_starttime
add-zsh-hook precmd set_longrunning_alert
# }}}

() { # local scope
local -A PINFO
local top middle bottom invisible middlecontent

PINFO=(
    virtenv     $'%(1V.%F{yellow}%B%S[%1v]%s%b%f .)'
    date        $'%b%F{cyan}%*'
    user-host   $'%b%(2V.%S%(!.%F{red}%K{11} %m %f%k.%F{yellow} %n@%m %f)%s.%(!.%F{red}%m%f.%F{green}%n@%m))'
    cmdstatus   $'%(?.${pipestatuscolor}.%K{red}%F{black})└─╢ $pipestatus_str ╟─╢ $cmd_runtime ╟${(r:$COLUMNS-13-$#pipestatus_str-$#cmd_runtime::─:)}┘%k%f'
    pwd         $'%F{blue}< %(6~|%-2~%F{blue}%B/…/%b%F{blue}%3~|%6~) >%f%b'
    jobs        $'%(1j.%B%F{cyan}(%j job%(2j.s.))%f%b .)'
    shlvl       $'%(2L.%F{magenta}#%L%f.)'
    histnum     $'%b%(2V.%(!.%F{red}.%F{yellow}).%(!.%F{red}.%F{green}))%h'
    vim         $'${vicmdindicator}'
    prompt      $'%#%b%f%k '
    prompt2     $'>%b%f%k '
    indent      $'%(2_:  :)%(3_:  :)%(4_:  :)%(5_:..:)'
)

top="$PINFO[cmdstatus]"
middleleft="$PINFO[date] $PINFO[user-host] $PINFO[pwd]"
middleright="$PINFO[virtenv]$PINFO[jobs]$PINFO[shlvl]"
bottom="$PINFO[histnum]$PINFO[vim]$PINFO[prompt]"

invisible='%([BSUbfksu]|([FK]|){*})'

middleleftcontent=${(S)middleleft//$~invisible}
middlerightcontent=${(S)middleright//$~invisible}

PROMPT="$top
$middleleft\${(r,\$COLUMNS - 1 -\${#\${(%):-$middleleftcontent$middlerightcontent}} % \$COLUMNS,)}$middleright
$bottom"

PROMPT2="$PINFO[histnum]$PINFO[indent]$PINFO[vim]$PINFO[prompt2]"

RPROMPT='${vcs_info_msg_0_}'

RPROMPT2=$'<%(!.%F{red}.%F{green})%^%b%f%k'
}

# {{{ zle line editor initialization
# Use add-zle-hook-widget (rather than overriding the special zle-line-*
# widgets directly) so these coexist with plugins that also hook them, e.g.
# fast-syntax-highlighting.
line-init-setup () {
    vicmd-indicator          # set initial vi indicator + cursor shape
    enter-kbd-transmit-mode
}
line-finish-teardown () {
    leave-kbd-transmit-mode
}
zle -N line-init-setup
zle -N line-finish-teardown
add-zle-hook-widget line-init line-init-setup
add-zle-hook-widget line-finish line-finish-teardown
# }}}

# {{{ redraw the current prompt when the terminal window is resized
# Only the prompt currently being edited can reflow; prompts already printed
# above are frozen scrollback and cannot be redrawn (a terminal stores rendered
# cells, not the prompt source). This keeps the width-sensitive parts -- the top
# rule and the right-aligned middle segment -- correct after a resize.
TRAPWINCH () {
    zle && { zle reset-prompt; zle -R }
}
# }}}

# {{{ set title on terminal (xterm, tmux, screen, rxvt)
xtermtitle() {
    # escape '%' chars in $1, make nonprintables visible

    # Truncate command, and join lines.

    local preamble="$(print -Pn -- '%y %n@%m: < %~ >')"
    local cl="${1:- }"
    local cmd="${${cl%% *}##*\/}"
    cl=$(print -nr -- "${cl:0:40}${${cl:40}:+...}" | tr "\n\t\v\f\r" " ") # shorten to 40 chars and remove fancy whitespace
    cl=${(V)cl}   # escape print specials
    cl=${cl//\\/\\\\}   # escape backslashes
    #cl=${(V)cl//\%/\%\%} # escape non-visibles and print specials

    case $TERM in
        screen*|tmux*)
            print -n -- "\e]2;[ZSH${TERMTITLE:+-}${TERMTITLE}] $preamble $cl\a" # plain xterm title
            print -n --  "\ek${cmd:-zsh}\e\\"      # screen title (in ^A")
            #print -Pn "\e_$1\e\\"   # screen location
            print -n -- "\e_$cl\e\\"   # screen location
            ;;
        *xterm*|rxvt*|alacritty|foot*|wezterm*)
            print -n -- "\e]2;[ZSH${TERMTITLE:+-}${TERMTITLE}] $preamble $cl\a" # plain xterm title
            ;;
    esac
}

xtermtitle_pc () {
    xtermtitle
}

xtermtitle_pe () {
    xtermtitle "$1"
}

case $TERM in
    *xterm*|screen*|tmux*|rxvt*|alacritty|foot*|wezterm*)
        add-zsh-hook precmd xtermtitle_pc
        add-zsh-hook preexec xtermtitle_pe
        ;;
esac
# }}}

histignore() {
    local line=${1%%$'\n'}
    [[ ${line: -2} == ' #' ]] && return 1
    print -sr -- $line
}
## does not work yet
#add-zsh-hook zshaddhistory histignore

# do automatic time for processes which use more CPU time
REPORTTIME=10
# extend and colorize time stats
TIMEFMT=$'\e[106;30m %J  %MMB maxmem %U user %S system %P cpu %*E total \e[0m'

# enable reloading of config with Ctrl+Alt+R
reload-config () {
    #print -Pn $'\e[s\e[2C%B%F{cyan}--> reloading configuration <--%b%f\e[u'
    local text='--> configuration reloaded '
    source ${ZDOTDIR:-$HOME}/.zshrc
    print -Pn $'\e[s\e[F\e[$[COLUMNS-$#text]C%F{cyan}$text%f\e[u'
}
zle -N reload-config
bindkey '^[R' reload-config
bindkey '^X^?' reload-config

# load additional configuration
for extraconf in ${ZDOTDIR:-$HOME}/.zshrc.d ${ZDOTDIR:-$HOME}/.zshrc.local.d; do
    for file in ${extraconf}/*.zsh(N); do
        source "$file"
    done
    unset file
done
