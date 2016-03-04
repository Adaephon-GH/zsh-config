# vim: fmr={{{,}}} fdm=marker cms=#\ %s :

# load dircolors here
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# addons
autoload -Uz zcalc
autoload -Uz zmv
autoload -Uz add-zsh-hook

# {{{ Completion
# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _approximate
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' file-sort name
zstyle ':completion:*' format '%F{blue}%U>>> %d%u%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' ignore-parents parent pwd .. directory
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
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' verbose true
zstyle :compinstall filename '/home/mruf/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Additional completion configuration
# for killall
zstyle ':completion:*:processes-names' command 'ps -e -o comm='
# for kill
zstyle ':completion:*:processes' command 'ps -a -u $USER -H -o pid,tty,time,command'
zstyle ':completion:*:processes' list-colors '=(#b) #([0-9]#)*=0=00;32'

ZSH_SPACE_SUFFIX_CHARS=$'|&'
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
setopt pushdignoredups

## History control
HISTFILE=~/.histfile
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

# {{{ command line prediction; WARNING: breaks zsh-syntax highlighting
autoload -Uz predict-on
zle -N predict-on
zle -N predict-off
predict-toggle() {
    (( predict_on = 1 - predict_on )) && zle predict-on || zle predict-off
}
zle -N predict-toggle
zstyle ':predict' toggle true
zstyle ':verbose' toggle true
# }}}

## I/O
unsetopt beep
setopt interactivecomments
setopt rematchpcre
#setopt printexitvalue

## job control
setopt autocontinue

## prompt
#setopt promptbang
setopt promptsubst
setopt promptpercent

# {{{ $terminfo helper functions
# Make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
# These are just helper functions that have to be added to
# zle-line-init and zle-line-finish respectively
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function enter-kbd-transmit-mode () {
        emulate -L zsh
        printf '%s' ${terminfo[smkx]}
    }
    function leave-kbd-transmit-mode () {
        emulate -L zsh
        printf '%s' ${terminfo[rmkx]}
    }
else
    function enter-kbd-transmit-mode leave-kbd-transmit-mode () { : }
fi
# }}}

# {{{ prompt formats for vcs information
### VCS INFORMATION
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable cvs git hg svn
## general settings
zstyle ':vcs_info:*' disable-patterns "/mnt(|/*)"
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
    # Abort if not in work-tree
    [[ $(git rev-parse --is-inside-work-tree) = 'false' ]] && return
    local staged unstaged untracked

    local -A counts
    counts=(
        $(git status --porcelain | awk '
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
export VIRTUAL_ENV_DISABLE_PROMPT=yes
function virtenv_indicator {
    if [[ -z $VIRTUAL_ENV ]]; then
        psvar[1]=''
    else
        psvar[1]=${VIRTUAL_ENV##*/}
    fi
}

add-zsh-hook precmd virtenv_indicator
# }}}

# {{{ function to determine if login is local or remote
logintype () {
    emulate -L zsh
    local lt h ps ppid=$PPID
    while (( ppid > 1 ))
    do
        ps=("${(f)$(ps lwp$ppid 2>/dev/null || ps -lp$ppid)}")
        h=($=ps[1])
        ps=($=ps[2])
        case "$ps" in
            *sshd*)
                # Shell running from ssh, probably not the local machine
                lt="remote"
                break
                ;;
            *(xterm|rxvt|dtterm|eterm|gnoterm|emacs|tmux|screen)*)
                # Shell running from an emulator, check for local displays
                if [[ -n $SSH_CLIENT ]]
                then
                    # Emulator started from ssh, probably port-forwarding
                    lt="remote"
                    break
                elif [[ $DISPLAY = ($HOST*|):* && ${HOSTDISPLAY:-$HOST} = $HOST* ]]
                then
                    # Shell running on a local display (though could be VNC)
                    lt="local"
                    break
                elif [[ -n $DISPLAY ]]
                then
                    # Shell running on a remote display
                    lt="remote"
                    break
                else
                    # Probably running inside a text-mode emacs
                fi
                ;;
            *login*)
                # Shell running on the local console, or from rlogin or telnet
                if [[ $TTY == /dev/pts/* || $TTY == /dev/tty[A-Za-z]* ]]
                then
                    # Shell running from rlogin or telnet
                    lt="remote"
                else
                    # Shell running on local console
                    lt="local"
                fi
                break
                ;;
            *)
                # Shell running from su or from some other shell or program
                if [[ -n $SSH_CLIENT ]]
                then
                    # Some ancestor is ssh, probably not local
                    lt="remote"
                    break
                fi
                ;;
        esac
        # Not enough information yet, climb the process tree
        ppid=${ps[$h[(i)PPID]]:-1}
    done
    echo $lt
}
psvar[2]=${$(logintype)#local}

# }}}

# {{{ get exit codes of previous command or pipeline
pipestatus () {
    pipestatus_=($pipestatus)
    pipestatuscolor='%B%F{green}'
    local excode
    for (( ec=1 ; ec <= $#pipestatus_ ; ec++ )) do
        if [ $pipestatus_[ec] -eq 0 ] ; then
            pipestatus_[ec]="ok"
        else
            pipestatuscolor='%B%F{yellow}' 
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
function zle-keymap-select {
    case $KEYMAP in
        vicmd) vicmdindicator='%S%Bv%s';;
        *) vicmdindicator=' ';;
    esac
    zle reset-prompt
}
zle -N zle-keymap-select
# }}}

typeset -A PINFO

PINFO=(
    virtenv     $'%(1V.%F{yellow}%B\{%1v\} %b%f.)'
    date        $'%b%F{cyan}%*'
    user-host   $'%b%(2V.%S%(!.%F{red}%K{11} %m %f%k.%F{yellow} %n@%m %f)%s.%(!.%F{red}%m%f.%F{green}%n@%m))'
    pipestatus  $'%(?.${pipestatuscolor}.%B%F{red})\u2514\u2500\u2562 $pipestatus_str \u255f${(r:$COLUMNS-7-$#pipestatus_str::\u2500:)}\u2518'
    pwd         $'%B%F{blue}< %~ >%f%b'
    jobs        $'%(1j. %B%F{yellow}(%j job%(2j.s.))%f%b.)'
    shlvl       $'%(2L. %F{magenta}#%L%f.)'
    histnum     $'%b%(2V.%(!.%F{red}.%F{yellow}).%(!.%F{red}.%F{green}))%h'
    vim         $'${vicmdindicator}'
    prompt      $'%#%b%f%k '
    prompt2     $'>%b%f%k '
    indent      $'%(2_:  :)%(3_:  :)%(4_:  :)%(5_:..:)'
)

top="$PINFO[pipestatus]"
middle="$PINFO[virtenv]$PINFO[date] $PINFO[user-host] $PINFO[pwd]$PINFO[jobs]$PINFO[shlvl]"
bottom="$PINFO[histnum]$PINFO[vim]$PINFO[prompt]"

invisible='%([BSUbfksu]|([FBK]|){*})'

middlecontent=${(S)middle//$~invisible}

PROMPT="$top$middle\${(r:\$COLUMNS - \${#\${(%)middlecontent}} % \$COLUMNS:)}$bottom"

PROMPT2="$PINFO[histnum]$PINFO[indent]$PINFO[vim]$PINFO[prompt2]"

RPROMPT='${vcs_info_msg_0_}'

RPROMPT2=$'<%(!.%F{red}.%F{green})%_%b%f%k'

# {{{ zle line editor initialization
function zle-line-init {
    zle zle-keymap-select
    enter-kbd-transmit-mode
}
function zle-line-finish {
    leave-kbd-transmit-mode
}
zle -N zle-line-init
zle -N zle-line-finish
# }}}

# {{{ set title on terminal (xterm, tmux, screen, rxvt)
function xtermtitle() {
    # escape '%' chars in $1, make nonprintables visible

    # Truncate command, and join lines.

    local preamble="$(print -Pn -- '%y %n@%m: < %~ >')"
    local cl="${1:-}"
    local cmd="${${cl%% *}##*\/}"
    cl=$(print -nr -- "${cl:0:40}${${cl:40}:+...}" | tr "\n\t\v\f\r" " ") # shorten to 40 chars and remove fancy whitespace
    cl=${(V)cl}   # escape print specials
    cl=${cl//\\/\\\\}   # escape backslashes
    #cl=${(V)cl//\%/\%\%} # escape non-visibles and print specials

    case $TERM in
        screen*)
            print -n -- "\e]2;[ZSH${TERMTITLE:+-}${TERMTITLE}] $preamble $cl\a" # plain xterm title
            print -n --  "\ek${cmd:-zsh}\e\\"      # screen title (in ^A")
            #print -Pn "\e_$1\e\\"   # screen location
            print -n -- "\e_$cl\e\\"   # screen location
            ;;
        *xterm*|rxvt*)
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
    *xterm*|screen*|rxvt*)
        add-zsh-hook precmd xtermtitle_pc
        add-zsh-hook preexec xtermtitle_pe
        ;;
esac
# }}}

# {{{ set alert on terminals after long running processes finish
typeset -i LONGRUNTIME=60

save_starttime () {
    starttime=$SECONDS
}

set_longrunning_alert () {
    if ((LONGRUNTIME > 0 && SECONDS - starttime >= LONGRUNTIME)); then
        print "\a"
    fi
}

add-zsh-hook preexec save_starttime
add-zsh-hook precmd set_longrunning_alert
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

# ZLE builtin highlighting (comment default if using zsh-syntax-highlighting)
zle_highlight[(r)default:*]="default:fg=white,bold" 
zle_highlight[(r)isearch:*]="isearch:fg=yellow,standout,bold"
zle_highlight[(r)suffix:*]="suffix:fg=magenta,bold"

# disable until https://github.com/zsh-users/zsh-syntax-highlighting/issues/108 is solved
#source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#source ~/.zsh/zsh-syntax-highlighting.conf

# load additional configuration
for extraconf in ~/.zsh/zshrc.d ~/.zsh.local/zshrc.d; do
    if [[ -d $extraconf ]]; then
        for file in ${extraconf}/*.zsh; do
            source "$file"
        done
        unset file
    fi
done

# enable reloading of config with Ctrl+Alt+R
reload-config () {
    #print -Pn $'\e[s\e[2C%B%F{cyan}--> reloading configuration <--%b%f\e[u'
    local text='--> configuration reloaded '
    source ~/.zshrc
    print -Pn $'\e[s\e[F\e[$[COLUMNS-$#text]C%F{cyan}$text%f\e[u'
}
zle -N reload-config
bindkey '^[R' reload-config
