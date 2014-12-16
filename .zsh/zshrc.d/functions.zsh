function termcolors () 
{
    print TERM

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

function mkcd () {
    mkdir "$@"
    cd "$1"
}
compdef _mkdir mkcd

function alertme () {
    local t=$1
    shift
    at $t <<EOM
notify-send '$t' '$@' -u critical
EOM

}

function zsh-git i3-git () {
    local GITDIR="${HOME}/config.git/${0%-git}-config/.git"
    git --work-tree="$HOME" --git-dir="$GITDIR" "$@"
}
compdef '_dispatch git git' zsh-git
compdef '_dispatch git git' i3-git

