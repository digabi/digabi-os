#!/bin/sh

set -e

if [ "$(id -u)" != 0 ]
then
    echo "E: Script must be run as root."
    exit 1
fi

COMMAND="$1"

if [ -z "${COMMAND}" ]
then
    COMMAND="compile"
fi

CONFIG_DIR="/etc/digabi/firewall.d"
RULEFILE="/etc/iptables/rules.v4"

FILES="$(ls ${CONFIG_DIR}/*.conf)"

case "${COMMAND}" in
    compile)
        TEMPFILE="$(mktemp)"
        for f in ${FILES}
        do
            echo "I: Adding firewall configuration: ${f}..." >&2
            if [ -x "${f}" ]
            then
                ${f} >>${TEMPFILE}
            else
                cat "${f}" >>${TEMPFILE}
            fi
        done

        if [ "${2}" = "save" ]
        then
            mv "${TEMPFILE}" "${RULEFILE}"
            chmod 0700 "${RULEFILE}"
            chown root:root "${RULEFILE}"
        else
            cat "${TEMPFILE}"
        fi
    ;;
    *)
        echo "E: Invalid command: ${COMMAND}"
        exit 1
    ;;
esac
