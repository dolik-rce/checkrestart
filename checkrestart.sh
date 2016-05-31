#!/bin/bash

export LC_ALL=C

usage() {
    echo "Usage:"
    echo "    $0 [-h|-v|-q]"
    echo
    echo "Options:"
    echo "    -h    Show help (this text)"
    echo "    -v    Be more verbose (and slower)"
    echo "    -q    Be less verbose (and quicker)"
}

init() {
    VERBOSITY=1
    while [ $# -gt 0 ]; do
        case "$1" in
            -q) VERBOSITY=0 ;;
            -v) VERBOSITY=2 ;;
            -h) usage; exit 0 ;;
            -*) printf "Error: Unknown option '$1'!\n\n"; usage; exit 1 ;;
        esac
        shift
    done

    if [ -t 1 ]; then
        # we can color output
        TITLE='\033[1;37m'
        NC='\033[0m'
    else
        # we shouldn't color
        TITLE=''
        NC=''
    fi

    # check what distribution is this
    if [ -f "/etc/debian_version" ]; then
        DISTRO="debian"
    elif [ -f "/etc/arch-release" ]; then
        DISTRO="arch"
    else
        echo "Warning: Unsupported distribution!"
    fi

    BLACKLIST="^/(sys|proc|dev|tmp|run|var|drm|SYSV)"
}

get_packages() {
    [ $# -gt 0 ] || return 0
    get_packages_$DISTRO $(echo "$@" | xargs -n1 readlink -mf) 2> /dev/stderr \
    | sed '1s/^/    Deleted files:  /;2,$s/^/                    /'
}

list_deleted() {
    lsof +L1 -dDEL +FLn
}

get_packages_arch() {
    pacman -Qo "$@" 2>&1 | sed '
        s/error: No package owns \(.*\)/\1 (N\/A)/;
        s/error: failed to read file '\''\(.*\)'\''.*/\1 (N\/A)/;
        s/\(.*\) is owned by \(\S*\).*/\1 (\2)/;'
}

get_packages_debian() {
    dpkg -S "$@" 2>&1 | sed 's/.*no path found matching pattern \(.*\)/\1 (N\/A)/;s/\(\S*\): \(.*\)/\2 (\1)/;'
}

flush() {
    NAMES="$(grep -Ev "$BLACKLIST" <<<"$NAMES" | sed 's/ (deleted)//' | sort -u)"
    if [ "$NAMES" ]; then
        CMD="$(sed 's/\x00/ /g;s/ *$//' /proc/$PID/cmdline)"
        if [ $VERBOSITY -eq 0 ]; then
            printf "%s\n" "$CMD"
        else
            printf "$TITLE%s$NC\n" "$CMD"
            echo "    PID:            $PID"
            echo "    User:           $USR"
            echo "    Running since:  $(ps -p $PID -o lstart=)"
            if [ $VERBOSITY -gt 1 ]; then
                echo "$(get_packages $NAMES)"
            fi
            echo
        fi
        COUNT=$(( $COUNT + 1 ))
        NAMES=""
    fi
}

main() {
    init "$@"
    COUNT=0
    while read -n 1 FIELD; do
        case $FIELD in
            p) flush; read PID ;;
            L) read USR;;
            n) read NAME; NAMES="$NAMES"$'\n'"$NAME" ;;
            *) read;;
        esac
    done < <(list_deleted)
    flush
    if [ -z "$COUNT" ]; then
        printf "${TITLE}Congratulations, everything is up-to-date!$NC\n"
    else
        printf "${TITLE}Found $COUNT out-of-date processes!$NC\n"
        return 1
    fi
}

main "$@"
