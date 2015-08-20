#!/bin/sh
set -e

DDIMAGE="$1"

[ -z "${DDIMAGE}" ] && echo "usage: $0 <path/to/image.dd>" && exit 1
[ ! -f "${DDIMAGE}" ] && echo "E: File not found: ${DDIMAGE}" && exit 1

VDIIMAGE="$(echo ${DDIMAGE} |sed 's,\.dd$,\.vdi,g')"

VBoxManage convertdd "${DDIMAGE}" "${VDIIMAGE}" --format VDI --variant Fixed
