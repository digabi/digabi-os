#!/bin/sh

#
# digabi-firewall
#
# This script compiles DigabiOS firewall rules to rule file
# to be used by iptables-persistent
#

set -e

CONFDIR="/etc/digabi/firewall.d"
[ -r /etc/default/digabios-firewall ] && . /etc/default/digabios-firewall

[ ! -d "${CONFDIR}" ] && echo "E: Config directory not found!" && exit 1

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

VERSIONS="v4 v6"

TEMPDIR="$(mktemp -d)"

for version in ${VERSIONS}
do
    TEMPFILE="${TEMPDIR}/rules.${version}"
    TARGETFILE="/etc/iptables/rules.${version}"
    CONFFILES="$(find ${CONFDIR} -maxdepth 1 -type f -name *.${version}.conf)"

    cat ${CONFFILES} >${TEMPFILE}
    echo "Rules for ${version}: ${TEMPFILE}"
done

