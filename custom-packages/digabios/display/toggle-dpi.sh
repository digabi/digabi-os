#!/bin/bash
#set -e

DEFAULT="96"
HIDPI="192"
TIMEOUT="15"

ZENITY="/usr/bin/zenity"
XFCONF="/usr/bin/xfconf-query"


close_firefox() {
    /usr/bin/wmctrl -c Firefox
    for i in $(seq 10)
    do
        pkill -0 firefox-esr || break
        sleep 0.2
    done

    pkill -9 firefox-esr 2>&1 >/dev/null
}

set_scaling_and_start_firefox() {
    local -r scaling="$1"
    local -r prefs_file="$(ls ~/.mozilla/firefox/*.default/prefs.js)"

    if grep -q layout.css.devPixelsPerPx "${prefs_file}"
    then
        sed -i -e "/layout.css.devPixelsPerPx/s/\"[0-9]*\"/\"${scaling}\"/" "${prefs_file}"
    else
        echo "user_pref(\"layout.css.devPixelsPerPx\", \"${scaling}\");" >> "${prefs_file}"
    fi

    xdg-open /usr/share/applications/digabi-koe-firefox-esr.desktop
}

wait_for_firefox_to_start() {
    for i in $(seq 10)
    do
        wmctrl -l -x | grep -qi firefox && break
        sleep 0.2
    done
    sleep 0.2
}

[ ! -x "${XFCONF}" ] && echo "E: xfconf-query not found!" && exit 1
[ ! -x "${ZENITY}" ] && echo "E: zenity not found!" && exit 1

CURRENT="$(${XFCONF} -c xsettings -p /Xft/DPI || echo ${DEFAULT})"
[ -z "${CURRENT}" ] && CURRENT="${DEFAULT}"

if [ "${CURRENT}" = "${DEFAULT}" ]
then
    NEW="${HIDPI}"
    FF_NEW_SCALING=2
    FF_OLD_SCALING=1
else
    NEW="${DEFAULT}"
    FF_NEW_SCALING=1
    FF_OLD_SCALING=2
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

close_firefox
set_scaling_and_start_firefox ${FF_NEW_SCALING}

wait_for_firefox_to_start

if ! ${ZENITY} --question --text "${QUESTION}" --timeout "${TIMEOUT}" --ok-label "${OK}" --cancel-label "${CANCEL}" 2>/dev/null
then
    echo "I: User asked to return previous value..."
    ${XFCONF} -n -c xsettings -p /Xft/DPI -t int -s ${CURRENT}
    close_firefox
    set_scaling_and_start_firefox ${FF_OLD_SCALING}
fi

exit 0
