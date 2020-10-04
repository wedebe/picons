#!/bin/bash

# shims for MacOS
# https://pretzelhands.com/posts/command-line-flags

mktemp() {
    mktemp_cmd=$(/usr/bin/mktemp "$@" 2> /dev/null)
    if [ ! $? -eq 0 ]; then
        # Default values of arguments
        ARGS=()

        # Loop through arguments and process them
        for arg in "$@"
        do
            case $arg in
                --suffix=*)
                local _rnd=$(echo "$(uuidgen)" | cut -d '-' -f 1)
                ARGS+=("${TMPDIR:-/tmp}$_rnd${arg#*=}")
                shift # Remove --initialize from processing
                ;;
                *)
                ARGS+=("$1")
                shift # Remove generic argument from processing
                ;;
            esac
        done
        mktemp_cmd=$(/usr/bin/mktemp ${ARGS[*]})
    fi
    echo $mktemp_cmd
}

touch() {
    touch_cmd=$(/usr/bin/touch "$@" 2> /dev/null)
    if [ ! $? -eq 0 ]; then
        # Default values of arguments
        ARGS2=()
        for arg in "$@"
        do
            case $arg in
                --no-dereference)
                ARGS2+=("-h")
                shift
                ;;
                *)
                ARGS2+=("$1")
                shift
                ;;
            esac
        done
        touch_cmd=$(/usr/bin/touch ${ARGS2[*]})
    fi
    echo $touch_cmd
}

tar() {
    tar_cmd=$(/usr/bin/tar "$@" 2> /dev/null)
    if [ ! $? -eq 0 ]; then
        ARGS3=()
        for arg in "$@"
        do
            case $arg in
                --owner=*)
                shift
                ;;
                --group=*)
                shift
                ;;
                *)
                ARGS3+=("$1")
                shift
                ;;
            esac
        done
        tar_cmd=$(/usr/bin/tar ${ARGS3[*]})
    fi
    echo $tar_cmd
}

date() {
    date_cmd=$(/bin/date "$@" 2> /dev/null)
    if [ ! $? -eq 0 ]; then
        ARGS4=()
        for arg in "$@"
        do
            case $arg in
                --utc)
                ARGS4+=("-u")
                shift
                ;;
                --date=@*)
                ARGS4+=("-r ${arg#*=@}")
                shift
                ;;
                *)
                ARGS4+=("$1")
                shift
                ;;
            esac
        done
        date_cmd=$(/bin/date ${ARGS4[*]})
    fi
    echo $date_cmd
}
