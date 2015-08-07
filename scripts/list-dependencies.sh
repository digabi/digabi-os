#!/bin/sh
set -e

RDEPS="/usr/bin/apt-rdepends"
[ ! -x "${RDEPS}" ] && echo "E: apt-rdepends not installed!" && exit 1

PACKAGES="$*"

${RDEPS} ${PACKAGES} |sed -e 's,  Depends: ,,g' -e 's,  PreDepends: ,,g' |sort -u
