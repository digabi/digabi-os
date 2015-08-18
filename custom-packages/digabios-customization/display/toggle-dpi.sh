#!/bin/sh
set -e

DEFAULT="92"
HIDPI="192"
TIMEOUT="15"

ZENITY="/usr/bin/zenity"
XFCONF="/usr/bin/xfconf-query"

[ ! -x "${XFCONF}" ] && echo "E: xfconf-query not found!" && exit 1
[ ! -x "${ZENITY}" ] && echo "E: zenity not found!" && exit 1

CURRENT="$(${XFCONF} -c xsettings -p /Xft/DPI)"
[ -z "${CURRENT}" ] && CURRENT="${DEFAULT}"

[ "${CURRENT}" = "${DEFAULT}" ] && NEW="${HIDPI}" || NEW="${DEFAULT}"

${XFCONF} -n -c xsettings -p /Xft/DPI -t int -s ${NEW}

zenity --question --timeout ${TIMEOUT} --text "OK?"
RETVAL="$?"

case "${RETVAL}"
in
    0)
    ;;
    1)
    ;;
    -1)
    ;;
    *)
    ;;
esac

exit 0
