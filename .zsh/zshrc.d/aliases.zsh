if [ -x /usr/bin/dircolors ]; then
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -lF'
alias la='ls -AlF'
alias ltr='ls -lFtr'
#alias l='ls -CF'

alias dir='ls -alF'                                            
#alias ..='cd ..'                                               
alias -g ...='../..'
alias -g ..2='../..'
alias -g ..3='../../..'
alias -g ..4='../../../..'
alias -g ..5='../../../../..'
alias -g ..6='../../../../../..'
alias -g ..7='../../../../../../..'
alias -g ..8='../../../../../../../..'
alias -g ..9='../../../../../../../../..'
#alias -- +='pushd'
#alias -- -='popd'
#alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(print -Pn "Process on %y finished\n${curcmd}")"; echo \\a'
alias xfreerdp="xfreerdp --sec rdp -g 1280x960 -k 0x00010407"

alias omplayer="mplayer -osdlevel 3 -use-filename-title -progbar-align 100 -fixed-vo"

alias congit='git --git-dir=$HOME/.config.git/ --work-tree=$HOME'
alias cgit="git --work-tree='$HOME' --git-dir=.git"

alias -g GG='| grep'

alias -g NPK='-o PubkeyAuthentication=no'

alias ssh-temp='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
