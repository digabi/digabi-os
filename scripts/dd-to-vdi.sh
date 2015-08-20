#!/bin/sh
set -e

DDIMAGE="$1"
VDIIMAGE="$(echo ${DDIMAGE} |sed 's,\.dd$,\.vdi,g')"

VBoxManage convertdd "${DDIMAGE}" "${VDIIMAGE}" --format VDI --variant Fixed
