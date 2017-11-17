termcolors () 
{
    print TERM

    print -P "Foreground: >█<"
    print -P "Background: >%S█%s<\n"

    print "      0 1 2 3 4 5 6 7" 
    for b (0 1)
    do
        printf "%d %2d " $b $(( 8 * b ))
        for r (0 1 2 3 4 5 6 7)
        do
            c=$(( 8 * b + r ))
            print -nP "%K{$c}  %k"
        done
        printf " %2d\n" $(( 8 * b + 7 ))
    done

    print

    print RGB
    for r (0 1 2 3 4 5)
    do 
        print "$r $(( 16 + 36 * r )) - $(( 16 + 36 * r + 35 ))\n       0 1 2 3 4 5"
        for g (0 1 2 3 4 5)
        do
            printf "%d %3d " $g $(( 16 + 36 * r + 6 * g ))
            for b (0 1 2 3 4 5)
            do
                c=$(( 16 + 36 * r + 6 * g + b ))
                print -nP "%K{$c}  %k"
            done
            printf " %3d\n" $(( 16 + 36 * r + 6 * g + 5))
        done
        print
    done

    print

    print GRAY
    for g in $(seq 0 23)
    do
        c=$(( 232 + g ))
        printf "%2d %3d " $g $c
        print -P "%K{$c}  %k"
    done
}

mkcd () {
    mkdir -p "$1"
    cd "$1"
}
compdef _mkdir mkcd

alertme () {
    local t=$1
    shift
    at $t <<EOM
notify-send 'ALERT $t' '$@' -u critical
EOM

}

# define git functions for all configurations in ${HOME}/config.git
function {
    local config_dirs=(${HOME}/config.git/*-config)
    local git_names=(${${config_dirs##*/}/%-config/-git})
    $git_names () {
        git -C "${HOME}/config.git/${0%-git}-config" "$@"
    }
    compdef '_dispatch git git' $git_names
}


# run git commands on all git repositories directly inside the current directory
subdirgit () {
    for dir in */.git(/N)
    do
        print -P "%F{black}%K{yellow}### ${dir:h} ###%f%k"
        git -C ${dir:h} $@
        print
    done
}
compdef '_dispatch git git' subdirgit


temp-ssh-agent () {
    case $1 in 
        enable) 
            if [[ -n $OLD_SSH_AUTH_SOCK ]]
            then
                echo "It seems there is already an temporary SSH agent running" >&2
                return 2
            fi
            export OLD_SSH_AUTH_SOCK=$SSH_AUTH_SOCK
            if [[ -n $SSH_AGENT_PID ]]
            then
                export OLD_SSH_AGENT_PID=$SSH_AGENT_PID
            fi
            eval $(ssh-agent -s)
            ;;
        disable)
            if [[ -z $OLD_SSH_AUTH_SOCK ]]
            then
                echo "It seems that there is no temporary SSH agent running" >&2
                return 2
            fi
            export SSH_AUTH_SOCK=$OLD_SSH_AUTH_SOCK
            unset OLD_SSH_AUTH_SOCK
            if [[ -n $SSH_AGENT_PID ]]
            then
                kill $SSH_AGENT_PID
                unset SSH_AGENT_PID
            fi
            if [[ -n $OLD_SSH_AGENT_PID ]]
            then
                export SSH_AGENT_PID=$OLD_SSH_AGENT_PID
                unset OLD_SSH_AGENT_PID
            fi
            ;;
        *)
            echo "Usage: $0 enable|disable" >&2
    esac
}

serfile () {
    setopt extended_glob
    local name=${1:-}
    local -a files
    files=( ${name}<1->(Nn) )
    echo $name$(( ${files[-1]#$name} + 1 ))
}
