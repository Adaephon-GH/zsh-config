tcheckcolors () {
    print $TERM

    print -P "Foreground: >█<"
    print -P "Background: >%S█%s<\n"

    print "16-color"
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

    print "256-color RGB (216 colors)"
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

    print "256-color grayscale (24 shades of gray)"
    for g in $(seq 0 23)
    do
        c=$(( 232 + g ))
        printf "%2d %3d " $g $c
        print -P "%K{$c}  %k"
    done
    print

    print "true color (24-bit)"
    for r in {0..9} {a..f}
        print -Pn '%K{#${r}00000} %K{#${r}70000} %k'
    print
    for g in {0..9} {a..f}
        print -Pn '%K{#00${g}000} %K{#00${g}700} %k'
    print
    for b in {0..9} {a..f}
        print -Pn '%K{#0000${b}0} %K{#0000${b}7} %k'
    print "\n"
    rainbow=(
        ff{00,11,22,2f,40,51,62,6f,80,91,a2,ae,bf,d0,e1,ee}00
        {ff,ee,e1,d0,bf,ae,a2,91,80,6f,62,51,40,2f,22,11}ff00
        00ff{00,11,22,2f,40,51,62,6f,80,91,a2,ae,bf,d0,e1,ee}
        00{ff,ee,e1,d0,bf,ae,a2,91,80,6f,62,51,40,2f,22,11}ff
        {00,11,22,2f,40,51,62,6f,80,91,a2,ae,bf,d0,e1,ee}00ff
        ff00{ff,ee,e1,d0,bf,ae,a2,91,80,6f,62,51,40,2f,22,11}
    )
    for c in $rainbow
        print -Pn '%K{#$c} %k'
    print
    print
    for c in {16..111}
        print -Pn '%K{#00${$(( [#16] 63+c ))#*\\#}${$(([#16] c))#*\\#}} %k'
    print
    for c in {16..111}
        print -Pn '%K{#00${$(( [#16] 63+c ))#*\\#}${$(([#16] 250-c*2))#*\\#}} %k'
    print
    for c in {16..111}
        print -Pn '%K{#${$(( [#16] 256-c ))#*\\#}00${$(([#16] c*2))#*\\#}} %k'
    print

}

tcheckcap () {
    print "\$TERM=$TERM"
    print
    print 'ZSH builtin effects'
    print
    print -P '%%B (%%b):  %Bboldface mode%b'
    print -P '%%U (%%u):  %Uunderlined mode%u'
    print -P '%%S (%%s):  %Sstandout mode%s'
    print -P 'combined: %B%U%Sboldface underline standout%s%u%b'
    print
    print 'ANSI escape codes'
    print
    print 'Basic codes'
    print '  0 ............. \e[0mReset or normal\e[0m'
    print '  1 ............. \e[1mBold or increased intensity\e[0m'
    print '  1:2 ........... \e[1:2mShadowed\e[0m'
    print '  2 ............. \e[2mFaint, decreased intensity, or dim\e[0m'
    print '  3 ............. \e[3mItalic\e[0m'
    print '  4 ............. \e[4mUnderline\e[0m'
    print '  4:1 ........... \e[4:1mUnderline\e[0m'
    print '  4:2 ........... \e[4:2mDouble underline\e[0m'
    print '  4:3 ........... \e[4:3mWavy underline\e[0m'
    print '  4:4 ........... \e[4:4mDotted underline\e[0m'
    print '  4:5 ........... \e[4:5mDashed underline\e[0m'
    print '  5 ............. \e[5mSlow blink\e[0m'
    print '  6 ............. \e[6mRapid blink\e[0m'
    print '  7 ............. \e[7mReverse video or invert\e[0m'
    print '  8 ............. \e[8mRConceal or hide\e[0m (Conceal or hide)'
    print '  9 ............. \e[9mCrossed-out or strike\e[0m'
    print ' 10 ............. \e[10mPrimary (default) font\e[0m'
    print ' 11 ............. \e[11mAlternative font 1 font\e[0m'
    print ' 12 ............. \e[12mAlternative font 2 font\e[0m'
    print ' 13 ............. \e[13mAlternative font 3 font\e[0m'
    print ' 14 ............. \e[14mAlternative font 4 font\e[0m'
    print ' 15 ............. \e[15mAlternative font 5 font\e[0m'
    print ' 16 ............. \e[16mAlternative font 6 font\e[0m'
    print ' 17 ............. \e[17mAlternative font 7 font\e[0m'
    print ' 18 ............. \e[18mAlternative font 8 font\e[0m'
    print ' 19 ............. \e[19mAlternative font 9 font\e[0m'
    print ' 20 ............. \e[20mFraktur (Gothic)\e[0m'
    print ' 21 ............. \e[21mDoubly underlined or not bold\e[0m'
    print ' 22 ............. \e[22mNormal intensity\e[0m'
    print ' 23 ............. \e[3m\e[23mNeither italic, nor blackletter\e[0m (\e[3mitalic <\e[23m>not italic\e[0m)'
    print ' 24 ............. \e[4\e[24mNot underlined\e[0m (\e[4munderlined <\e[24m> not underlined\e[0m)'
    print ' 25 ............. \e[5\e[25mNot blinking\e[0m (\e[5mslow blinking <\e[25m> not blinking\e[0m)'
    print ' 25 ............. \e[5\e[25mNot blinking\e[0m (\e[6mrapid blinking <\e[25m> not blinking\e[0m)'
    print ' 26 ............. \e[26mProportional spacing\e[0m'
    print ' 27 ............. \e[7\e[27mNot reversed\e[0m (\e[7mreversed <\e[27m> not reversed\e[0m)'
    print ' 28 ............. \e[8\e[28mNot concealed\e[0m (\e[8mconcealed <\e[28m> not concealed\e[0m)'
    print ' 29 ............. \e[9\e[29mNot crossed-out\e[0m (\e[9mcrossed-out <\e[29m> not crossed-out\e[0m)'
    print ' 30-37 .......... \e[31mSet foreground color (31 red)\e[0m'
    print ' 38;5;1 ......... \e[38;5;1mSet foreground color 3-bit (1 red)\e[0m'
    print ' 38:5:1 ......... \e[38:5:1mSet foreground color 3-bit (1 red, colon as parameter separator)\e[0m'
    print ' 38;5;160 ....... \e[38;5;160mSet foreground color 8-bit (160 red)\e[0m'
    print ' 38:5:160 ....... \e[38:5:160mSet foreground color 8-bit (160 red, colon as parameter separator)\e[0m'
    print ' 38;2;225;20;20 . \e[38;2;225;20;20mSet foreground color 24-bit (#E11414 red)\e[0m'
    print ' 38:2:225:20:20 . \e[38:2:225:20:20mSet foreground color 24-bit (#E11414 red, colon as parameter separator)\e[0m'
    print ' 39 ............. \e[31m\e[39mSet default foreground color\e[0m (\e[31mred <\e[39m> not red (probably)\e[0m)'
    print ' 40-47 .......... \e[41mSet background color (41 red)\e[0m'
    print ' 48;5;1 ......... \e[48;5;1mSet background color 3-bit (1 red)\e[0m'
    print ' 48:5:1 ......... \e[48:5:1mSet background color 3-bit (1 red, colon as parameter separator)\e[0m'
    print ' 48;5;160 ....... \e[48;5;160mSet background color 8-bit (160 red)\e[0m'
    print ' 48:5:160 ....... \e[48:5:160mSet background color 8-bit (160 red, colon as parameter separator)\e[0m'
    print ' 48;2;225;20;20 . \e[48;2;225;20;20mSet background color 24-bit (#E11414 red)\e[0m'
    print ' 48:2:225:20:20 . \e[48:2:225:20:20mSet background color 24-bit (#E11414 red, colon as parameter separator)\e[0m'
    print ' 49 ............. \e[41m\e[49mSet default background color\e[0m (\e[41mred <\e[49m> not red (probably)\e[0m)'
    print ' 50 ............. \e[26m\e[50mDisabled proportional spacing\e[0m (\e[24m(maybe) proportionally spaced <\e[50m> not proportionally spaced\[0m)'
    print ' 51 ............. \e[51mFramed\e[0m'
    print ' 52 ............. \e[52mEncircled\e[0m'
    print ' 53 ............. \e[53mOverlined\e[0m'
    print ' 54 ............. \e[51m\e[52m\e[54mNeither framed nor encircled\e[0m (\e[51m\e[52m(maybe) framed and/or encircled <\e[54m> neither framed nor encircled\e[0m)'
    print ' 55 ............. \e[53m\e[55mNot overlined\e[0m (\e[53m(maybe) overlined <\e[55m> not overlined\[0m)'
    print ' 58;5;1 ..........\e[4;58;5;1mSet underline color 3-bit (1 red)\e[0m'
    print ' 58:5:1 ..........\e[4;58:5:1mSet underline color 3-bit (1 red, colon as parameter separator)\e[0m'
    print ' 58;5;160 ........\e[4;58;5;160mSet underline color 8-bit (160 red)\e[0m'
    print ' 58:5:160 ........\e[4;58:5:160mSet underline color 8-bit (160 red, colon as parameter separator)\e[0m'
    print ' 58;2;225;20;20 ..\e[4;58;2;225;20;20mSet underline color 24-bit (#E11414 red)\e[0m'
    print ' 58:2:225:20:20 ..\e[4;58:2:225:20:20mSet underline color 24-bit (#E11414 red, colon as parameter separator)\e[0m'
    print ' 59 ............. \e[4;58;5;1m\e[59mSet default undererline color\e[0m (\e[4;58;5;1mred <\e[59m> not red (probably)\e[0m)'
    print ' 60 ............. \e[60mIdeogram underline, or right side line\e[0m'
    print ' 61 ............. \e[61mIdeogram double underline, or double line on the left side\e[0m'
    print ' 62 ............. \e[62mIdeogram overline, left side line\e[0m'
    print ' 63 ............. \e[63mIdeogram double overline, or double line on the left side\e[0m'
    print ' 64 ............. \e[64mIdeogram stress marking\e[0m'
    print ' 65 ............. \e[60m\e[65mNo ideogram attributes\e[0m (\e[60munderline or right side line <\e[65m> no underline or right side line (probably)\e[0m)'
    print ' 73 ............. \e[73mSuperscript\e[0m'
    print ' 74 ............. \e[74mSubscript\e[0m'
    print ' 75 ............. \e[73m\e[75mNeither subscript nor subcript\e[0m (\e[73msuperscript <\e[75m>no superscript\e[0m)'
    print ' 90-67 .......... \e[91mSet bright foreground color (91 red)\e[0m'
    print '100-107 ......... \e[101mSet bright background color (101 red)\e[0m'
    print
    print 'Combinations'
    print ' 1;2 ............ \e[1;2mBold and faint\e[0m'
    print ' 1;3 ............ \e[1;3mBold and italic\e[0m'
    print ' 1;4 ............ \e[1;4mBold and underlined\e[0m'
    print ' 1;21 ........... \e[1;21mBold and doubly underlined (or: bold and not bold)\e[0m'
    print ' 1;5 ............ \e[1;5mBold and slow blinking\e[0m'
    print ' 1;7 ............ \e[1;7mBold and inverted\e[0m'
    print ' 1;9 ............ \e[1;9mBold and crossed-out\e[0m'
    print ' 1;31 ........... \e[1;31mBold and red foreground\e[0m'
    print ' 1;41 ........... \e[1;41mBold and red background\e[0m'
    print ' 41 ............. \e[41mRed background\e[0m'
    print ' 31;7 ........... \e[31;7mRed foreground and inverted\e[0m'
    print ' 1;7;31 ......... \e[1;7;31mBold, red foreground and inverted\e[0m'
    print ' 1;7;31;2 ....... \e[1;7;31;2mBold, red foreground, inverted and faint\e[0m'
    print ' 1;7;31;22 ...... \e[1;7;31;22mBold, red foreground, inverted and normal intensity\e[0m'
    print ' 1;7;41 ......... \e[1;7;41mBold, red background and inverted\e[0m'
    print ' 1;7;41;2 ....... \e[1;7;41;2mBold, red background, inverted and faint\e[0m'
    print ' 1;2;3;4;5;9 .... \e[1;2;3;4;5;9mBold, faint, italic, underlined, blinking and crossed-out\e[0m'
    print ' 4;53 ........... \e[4;53mUnderlined and overlined\e[0m'
    print ' 4;9;53 ......... \e[4;9;53mUnderlined, crossed-out and overlined\e[0m'
    print ' 4;58;5;1 ....... \e[4;58;5;1mUnderlined and red underline color\e[0m'
    print ' 21;58;5;1 ...... \e[21;58;5;1mDoubly underlined and red underline color\e[0m'
    print ' 53;58;5;1 ...... \e[53;58;5;1mOverlined and red underline color\e[0m'

}

mkcd () {
    mkdir -p "$1"
    cd "$1"
}
compdef _mkdir mkcd

alertme alertme-hp() {
    local type=$1 time=$2 set_at=$(date +'%F %T')
    shift 2
    cmd=(systemd-run --user)
    case $type in
        every)
            cmd+="--on-calendar=$time"
            ;;
        at)
            cmd+="--on-calendar=$(date -d $time +'%F %T')"
            ;;
        in)
            cmd+="--on-active=$time"
            ;;
        *)
            echo "Expected 'at' or 'in' as first argument" >&2
            return 1
            ;;
    esac
    [[ $0 == *-hp ]] && cmd+="--timer-property=AccuracySec=10ms"
    $cmd notify-send "ALERT $type $time" "Set at: $set_at\n$*" -u critical
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
psubdirgit () {
    parallel 'print -P "%F{black}%K{yellow}### {} ###%f%k" ; git -C {} ' $@ ::: */.git(/N:h)
}
compdef '_dispatch git git' subdirgit psubdirgit


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
    local pad=${2:-4}
    local -a files
    files=( ${name}<1->(Nn) )
    echo $name${(l:$pad::0:)$(( ${files[-1]#$name} + 1 ))}
}

seecert () {
    host=${1:?Missing host parameter}
    port=${2:-443}
    openssl s_client -showcerts -servername $host -connect $host:$port <<< "Q" | openssl x509 -text
}

