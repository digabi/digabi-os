#!/bin/bash
#set -e

restart_xfce4_panel () {
    ${XPANEL} --restart
    # Sometimes xfc4-panel restart fails and actually only shutsdown the panel.
    # Try to start panel again.
    sleep 1
    ${XPANEL} &
}

DEFAULT="96"
HIDPI="192"
TIMEOUT="15"

ZENITY="/usr/bin/zenity"
XFCONF="/usr/bin/xfconf-query"
XPANEL="/usr/bin/xfce4-panel"

[ ! -x "${XPANEL}" ] && echo "E: xfce4-panel not found!" && exit 1
[ ! -x "${XFCONF}" ] && echo "E: xfconf-query not found!" && exit 1
[ ! -x "${ZENITY}" ] && echo "E: zenity not found!" && exit 1

CURRENT="$(${XFCONF} -c xsettings -p /Xft/DPI 2>/dev/null || echo ${DEFAULT})"
[ -z "${CURRENT}" ] && CURRENT="${DEFAULT}"

if [ "${CURRENT}" = "${DEFAULT}" ]
then
    NEW="${HIDPI}"
else
    NEW="${DEFAULT}"
fi

case "${LANG}"
in
    fi*)
        QUESTION="Haluatko säilyttää nykyisen asetuksen?"
        OK="Ok"
        CANCEL="Peru"
    ;;
    sv*)
        QUESTION="Vill du behålla den nuvarande inställningen?"
        OK="Ok"
        CANCEL="Avbryt"
    ;;
    *)
        QUESTION="Do you want to keep the current setting?"
    ;;
esac

echo "I: Set DPI to ${NEW} (was: ${CURRENT})"
${XFCONF} -n -c xsettings -p /Xft/DPI -t int -s ${NEW}
restart_xfce4_panel

if ! ${ZENITY} --question --text "${QUESTION}" --timeout "${TIMEOUT}" --ok-label "${OK}" --cancel-label "${CANCEL}" 2>/dev/null
then
    echo "I: User asked to return previous value..."
    ${XFCONF} -n -c xsettings -p /Xft/DPI -t int -s ${CURRENT}
    restart_xfce4_panel
fi

exit 0
